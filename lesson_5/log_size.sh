#!/bin/bash
touch /home/mykola_nemo/lesson_5/log_size_res.txt
list=`ls -p /var/log/ | egrep -v /`
echo "$list"
list_2=`ls -Sh -p /var/log/ | egrep -v /`
echo "$list_2">> /home/mykola_nemo/lesson_5/log_size_res.txt