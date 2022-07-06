#!/bin/bash
touch /home/mykola_nemo/lesson_5/etc_dir.txt
for file in /etc/*
do
if [ -d $file ]
then
echo "$file" >> /home/mykola_nemo/lesson_5/etc_dir.txt
fi
done
