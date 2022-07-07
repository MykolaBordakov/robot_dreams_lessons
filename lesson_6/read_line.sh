#!/bin/bash
touch /home/mykola_nemo/lesson_6/cmd_names.txt
exec 0< /home/mykola_nemo/lesson_6/usr_executables.txt
count=1
while read line
do
    echo "Line #$count: $line"
    file_name=${line##*/}
    echo "$file_name" >> /home/mykola_nemo/lesson_6/cmd_names.txt
    count=$(( $count + 1 ))
    if (( $count == 11 ))
        then
        break
    fi
done
