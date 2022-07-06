#!/bin/bash
touch /home/mykola_nemo/lesson_5/executable.txt
for file in /usr/bin/*
do
if [ -f $file ]
then
if [ -x $file ]
then
echo "$file" >> /home/mykola_nemo/lesson_5/executable.txt
fi
fi
done
