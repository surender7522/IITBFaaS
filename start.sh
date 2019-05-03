#! /bin/bash
echo "Enter ip of manager:"
read input
sudo sysctl fs.inotify.max_user_watches=1048576
export GOPATH=$GOROOT/bin
echo "Compiling Golang server..."
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o maincppost maincppost.go
chmod 777 maincppost
docker swarm init --advertise-addr $input
cp alertmanager/conf/alertmanager.yml alertmanager/conf/alertmanager.yml.temp
echo -e "\n    url: 'http://$input:2000'\n">> alertmanager/conf/alertmanager.yml
nohup ./maincppost > /dev/null 2>&1 &
ADMIN_USER=admin ADMIN_PASSWORD=admin SLACK_URL=https://hooks.slack.com/services/TOKEN SLACK_CHANNEL=devops-alerts SLACK_USER=alertmanager docker stack deploy -c docker-compose.yml mon
