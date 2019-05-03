#! /bin/bash
IFS=$' ' read -d '' -r -a HOSTS < nodes.txt
for i in ${HOSTS[*]} ; do
	IFS=',' read USERNAME HOSTNAME PASS <<< "${i}"
	echo ${USERNAME} ${HOSTNAME} ${PASS}
	SCRIPT="sudo $(sudo docker swarm join-token worker|grep "docker swarm join")"
	SCRIPT1="sudo sysctl fs.inotify.max_user_watches=1048576"
        #echo $SCRIPT
    sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
    sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} "${SCRIPT1}"
done
