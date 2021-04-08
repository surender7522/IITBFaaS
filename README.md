# IITBFaaS
[Project Report with architecture and tests](https://github.com/surender7522/IITBFaaS/blob/master/ProjectReport.pdf)

# Architecture
<img width="483" alt="Screen Shot 2021-04-08 at 15 10 05" src="https://user-images.githubusercontent.com/10762179/113976937-c1386f80-987c-11eb-949e-df2e57780e50.png">

<img width="974" alt="Screen Shot 2021-04-08 at 15 09 58" src="https://user-images.githubusercontent.com/10762179/113976957-c85f7d80-987c-11eb-98ea-bc8292f374e1.png">

<img width="958" alt="Screen Shot 2021-04-08 at 15 10 19" src="https://user-images.githubusercontent.com/10762179/113976963-cc8b9b00-987c-11eb-869e-65c5251cec9a.png">


Contents:
1. Installation
2. Setup of nodes
3. Startup
4. Adding Functions
5. Stopping
6. Removing Functions

1. Installation:
On all the nodes(only tested on ubuntu 16.04/16.10), run 
sudo -s
./installdockerenv.sh

--The following requires non IITB network due to TLS handshake timeout on our network
sudo -s
./pullfaasimages.sh

2. Setup of nodes
Connect all the nodes on same lan and add the tuple,(username,ip,password) for all non manager nodes into nodes.txt of manager node
Ex: mridul,10.5.32.84,password surender,10.5.32.54,123456789 .....

Run the following commands on the node which will act as proxy:
sudo apt install haproxy
and place the file haproxy.cfg at /etc/haproxy/haproxy.cfg
and edit the file to add all the nodes ip addresses including manager to the file as shown:

server node1 10.5.32.84 port 8590 check
server node2 10.5.32.54 port 8590 check
and then run:
sudo systemctl restart haproxy

3. Startup
On the manager node, run the following commands and respond to prompts as they appear
sudo -s
./start.sh
./addnodes.sh
Now all the containers will be visible on 127.0.0.1:9090 from manager

4.Adding functions
Go into functionbuilder/ and remove any existing binaries and place your statically compiled binary there
Edit main.go at two places as described, be careful to use the name of your binary and choose a non existing port number(can be seen with "sudo ufw status" for existing mappings) in 2000-9000 range
Then run:
./build.sh and follow prompts
Verify that function is running from prometheus on port 9090 or "sudo docker stack ps mon"

5. Stopping
run:
sudo -s
./stop.sh

6. Removing Functions:
Removing functions requires changes in docker-compose.yml and prometheus/conf/prometheus.yml, just remove the function's code block from both places

7. Useful ports:
Prometheus(For seeing targets/containers running) port 9090
Grafana(Visualize metrics) port 3000
Alert manager(shows alerts and configuration) port 9093
Unsee(shows active alerts, auto updates) port 9094

Troubleshooting tips:
Sometimes alertmanager/conf/alertmanager.yml gets overwritten, replace it with the backup in same folder
"docker stack ps mon" shows the whole stack info
docker service ls -f "NAME=mon_surenderbetatest" shows the service info and replicas etc
docker node ls shows active nodes
