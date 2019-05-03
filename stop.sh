sudo docker stack rm mon
rm alertmanager/conf/alertmanager.yml
mv alertmanager/conf/alertmanager.yml.temp alertmanager/conf/alertmanager.yml
IFS=$' ' read -d '' -r -a HOSTS < nodes.txt
for i in ${HOSTS[*]} ; do
	IFS=',' read USERNAME HOSTNAME PASS <<< "${i}"
	#echo ${USERNAME} ${HOSTNAME} ${PASS}
	SCRIPT="sudo docker swarm leave --force"
    sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
done
sudo docker swarm leave --force
sudo killall -9 maincppost
