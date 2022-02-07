#!/bin/bash

curl -s 'http://192.168.1.22/.hidden/' > urls.txt
i=0
while read line
do
    # echo -e "$line";
    echo $line | cut -d'>' -f2 | cut -d'/' -f1
    echo {$i++}
done < urls.txt