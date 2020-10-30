sudo apt update

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -a -G docker $USER
sudo chmod 666 /var/run/docker.sock

sudo ufw allow 22/tcp   comment 'ssh'
sudo ufw allow 2377/tcp comment 'cluster management communications'
sudo ufw allow 7946     comment 'communication among nodes'
sudo ufw allow 4789/udp comment 'overlay network traffic'
sudo ufw enable


# MYSQL CLUSTER
sudo apt-get update
sudo apt-get install mysql-apt-config
sudo apt-get install mysql-cluster-community-server #SQL NODE
#sudo apt-get install mysql-cluster-community-management-server #MANAGEMENT NODE
#sudo apt-get install mysql-cluster-community-data-node #DATA NODE
groupadd mysql
useradd -g mysql -s /bin/false mysql
