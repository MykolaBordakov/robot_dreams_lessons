#!/bin/bash
if [ -x  /home/mykola_nemo/lesson_7/executable.txt  ]; then 
    rm /home/mykola_nemo/lesson_7/executable.txt 
fi
touch /home/mykola_nemo/lesson_5/log_size_res.txt
for file in /usr/bin/*
do
if [ -f $file ]
then
if [ -x $file ]
then
echo "$file" >> /home/mykola_nemo/lesson_7/executable.txt
fi
fi
done