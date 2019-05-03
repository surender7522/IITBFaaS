#! /bin/bash
sudo apt-get update
sudo apt-get --yes install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get --yes install docker-ce
sudo snap install --classic go
sudo sysctl fs.inotify.max_user_watches=1048576
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp
sudo ufw allow 9323/tcp
sudo ufw allow 2000
sudo echo -e '{\n  "metrics-addr" : "0.0.0.0:9323",\n  "experimental" : true\n}'>/etc/docker/daemon.json
username=$(logname)
sudo echo "$username ALL = NOPASSWD: /usr/bin/docker, /usr/sbin/ufw, /sbin/sysctl">>/etc/sudoers
sudo systemctl restart docker
sudo apt -y install git
sudo apt -y install sshpass
sudo apt -y install openssh-server
sudo systemctl enable ssh
sudo systemctl restart ssh
sudo ufw allow ssh
sudo ufw enable
