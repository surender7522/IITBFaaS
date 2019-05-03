#! /bin/bash
var=$(($(sudo docker service ls -f "NAME=$1" --format "{{.Replicas}}"|sed 's/\/.*//')+($2)))
if (( $var < 1 ));
then
   echo "lower than 1 scaling not allowed, ignored"
else
   sudo docker service scale $1=$var
fi
