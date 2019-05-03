#! /bin/bash
export GOPATH=$GOROOT/bin
echo "Compiling Golang server..."
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main main.go
rm Dockerfile.scratch
echo "FROM scratch">>Dockerfile.scratch
files=(*)
for item in ${files[*]}
do
  if !(test "$item" = "build.sh" || test "$item" = "Dockerfile.scratch" || test "$item" = "main.go" || test "$item" = "readme"); then
  	echo "ADD "$item" /">>Dockerfile.scratch
  fi
done
echo CMD "[\"/main\"]">>Dockerfile.scratch
echo "Login to Docker Hub:"
docker login
echo "Enter a name for your image:"
read input
docker build -t $input -f Dockerfile.scratch .
echo "Enter DockerHub Username"
read username
docker tag $input":latest" $username/$input
echo "Enter Port Selected"
read port
sudo ufw allow $port
echo -e "\n  "$input":\n    image: "$username"/"$input"\n    ports:\n      - \""$port:$port"\"\n    networks:\n      - net\n    deploy:\n      mode: replicated\n      replicas: 1\n      \n">>../docker-compose.yml
echo -e "  - job_name: '"$input"'\n    dns_sd_configs:\n    - names:\n      - 'tasks."$input"'\n      type: 'A'\n      port: "$port"\n">>../prometheus/conf/prometheus.yml
docker kill $(docker ps -q --filter ancestor=prom/prometheus:v2.5.0)
echo "Push can fail on IITB Network, Otherwise try, docker push "$username"/"$input
echo "Run docker pull "$username"/"$input" on all the other nodes afterwards"
docker push $username/$input
IFS=$' ' read -d '' -r -a HOSTS < ../nodes.txt
SCRIPT="sudo docker pull $username/$input"
SCRIPT1="sudo ufw allow $port"
for i in ${HOSTS[*]} ; do
	IFS=',' read USERNAME HOSTNAME PASS <<< "${i}"
	#echo ${USERNAME} ${HOSTNAME} ${PASS}
    sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
    sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} "${SCRIPT1}"
done
ADMIN_USER=admin ADMIN_PASSWORD=admin SLACK_URL=http://10.5.32.185:2000 SLACK_CHANNEL=devops-alerts SLACK_USER=alertmanager docker stack deploy -c ../docker-compose.yml mon
