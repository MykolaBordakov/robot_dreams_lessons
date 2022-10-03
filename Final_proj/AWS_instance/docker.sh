#!/bin/bash

username="ubuntu"
sudo mkdir /home/${username}/results
sudo touch /home/${username}/results/docker-install.txt
sudo chmod 777 /home/${username}/results/docker-install.txt

#Оновлюємо пакети системи
sudo touch /home/${username}/results/apt-update.txt
sudo chmod 777 /home/${username}/results/apt-update.txt 
sudo apt update >> /home/${username}/results/apt-update.txt

#Встановлюємо потрібні для роботи докера пакети
sudo touch /home/${username}/results/support.txt
sudo chmod 777 /home/${username}/results/support.txt 
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common >> /home/${username}/results/support.txt

#Встановлюємо NGINX веб сервер
sudo touch /home/${username}/results/nginx-install.txt
sudo chmod 777 /home/${username}/results/nginx-install.txt
sudo apt install -y nginx >> /home/${username}/results/nginx-install.txt
sudo ufw allow 'Nginx Full'
sudo ufw status >> /home/${username}/results/nginx-install.txt
sudo systemctl status nginx >> /home/${username}/results/nginx-install.txt

#Встановлюємо Docker веб сервер
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update >> /home/${username}/results/apt-update.txt
apt-cache policy docker-ce >> /home/${username}/results/docker-install.txt
sudo apt install -y docker-ce >> /home/${username}/results/docker-install.txt
sudo systemctl status docker >> /home/${username}/results/docker-install.txt

sudo usermod -aG docker ${username}
sudo su - ${username}
groups >> /home/${username}/results/docker-install.txt

#Встановлюємо Docker-comopse веб сервер
sudo apt  install -y docker-compose >> /home/${username}/results/docker-install.txt
docker-compose version >> /home/${username}/results/docker-install.txt

#Працюємо з образом jenkins 
docker pull jenkins/jenkins
sudo mkdir /home/${username}/jenkins_vol
sudo chmod 777 /home/${username}/jenkins_vol
docker run -d --name myjenkins -e JENKINS_OPTS="--prefix=/jenkins" -p 8080:8080  -v /home/${username}/jenkins_vol:/var/jenkins_home jenkins/jenkins

sudo unlink /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/nginx.conf
sudo chmod 777 /etc/nginx/sites-available/nginx.conf
sudo echo "server {
    listen 80;
    location /jenkins {
        proxy_pass http://0.0.0.0:8080/jenkins;
    }
}" >> /etc/nginx/sites-available/nginx.conf
sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo service nginx restart
sudo chmod 755 /etc/nginx/sites-available/nginx.conf