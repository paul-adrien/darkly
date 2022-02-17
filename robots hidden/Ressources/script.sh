#!/bin/bash

loop() {
    local url=$(echo "$1")

    if [ "$2" == 1 ];
    then
        curl -s $url >> results.txt
        return
    else
        local lines=$(curl -s $url)
    fi

    local array=($(echo $lines | grep -o href=\"[A-z]* | cut -d'"' -f2))
    
    for line in "${array[@]}"
    do
        if [ "$line" != "" -a "$line" != "README" ]; then
            loop "$url$line/"
        elif [ "$line" != "" -a "$line" == "README" ]; then
            loop "$url$line" 1
        fi
    done
}

loop 'http://192.168.56.101/.hidden/'