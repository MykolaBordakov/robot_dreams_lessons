#!/bin/bash
touch /home/mykola_nemo/lesson_6/usr_executables.txt
for file in /usr/bin/*
do
    if [ -f $file ]
        then
        if [ -x $file ] || [ -r $file ]
            then
            echo "$file" >> /home/mykola_nemo/lesson_6/usr_executables.txt
            fi
    fi
done
