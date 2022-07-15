#!/bin/bash
servstat=$(service apache2 status)
if [[ $servstat == *"apache2 is running"* ]]; then
  echo "process is running"
  pid=$(ps aux | grep apache2 | grep root | grep -v grep | awk '{print $2}')
  name=$(ps aux | grep apache2 | grep root | grep -v grep | awk '{print $11}')
  kill -15 "$pid"
echo "Process $name $pid stopped"
else echo "process is not running"
fi
