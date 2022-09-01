FROM ubuntu:20.04

LABEL maintainer="Mykol :)"

ENV Status="OK"

ENV TZ=Europe/Kiev

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update

RUN apt-get install python3 -y

RUN apt-get install net-tools -y

RUN apt-get install apache2 -y

COPY . .



RUN mv ./index.html /var/www/html/

RUN echo "ServerName 0.0.0.0" >> /etc/apache2/apache2.conf

RUN . /etc/apache2/envvars

CMD ["apachectl", "-D", "FOREGROUND"] && \
    [ "/bin/bash", "./test.sh" ]


RUN service apache2 restart

VOLUME /devops_volume

EXPOSE 8000