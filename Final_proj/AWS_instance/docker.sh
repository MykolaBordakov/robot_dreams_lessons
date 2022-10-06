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
#Створюєм HTTPS сертифікат
country=GB
state=Nottingham
locality=Nottinghamshire
organization=dude.net
organizationalunit=IT
email=administrator@dude.net
sudo mkdir /etc/nginx/ssl
sudo touch /home/${username}/results/cert.txt
sudo chmod 777 /home/${username}/results/cert.txt 
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" >> /home/${username}/results/cert.txt 
sudo touch /etc/nginx/sites-available/nginx.conf
sudo chmod 777 /etc/nginx/sites-available/nginx.conf
sudo echo "server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    location /jenkins {
        proxy_pass http://0.0.0.0:8080/jenkins;
    }
}" >> /etc/nginx/sites-available/nginx.conf
sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
#Додаєм образ графани
#ip_garf=$(wget -qO- http://ipecho.net/plain | xargs echo)
docker pull grafana/grafana
docker run -d   -p 3000:3000   --name=grafana \
grafana/grafana
sudo touch /etc/nginx/sites-available/nginx_graf.conf
sudo chmod 777 /etc/nginx/sites-available/nginx_graf.conf


sudo echo "server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    location /grafana {
        proxy_pass http://0.0.0.0:3000;
    }
}" >> /etc/nginx/sites-available/nginx_graf.conf


sudo ln -s /etc/nginx/sites-available/nginx_graf.conf /etc/nginx/sites-enabled/nginx_graf.conf
sudo systemctl restart nginx
