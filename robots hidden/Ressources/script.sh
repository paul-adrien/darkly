#!/bin/bash

curl -s 'http://192.168.56.101/.hidden/' > urls.txt

while read line
do
    tmp=$(echo $line | cut -d'>' -f2 | cut -d'/' -f1)
    size=${#tmp}
    if [ "$size" = 26 ]
    then
        curl -s "http://192.168.56.101/.hidden/$tmp" > urls2.txt
        while read line2
        do
            tmp2=$(echo $line | cut -d'>' -f2 | cut -d'/' -f1)
            echo "$tmp2"
        done < urls2.txt
    fi
done < urls.txt

loop() {
    local url=$(echo "$1")
    local response=$(curl -s $url)
    local array
}

loop 'http://192.168.56.101/.hidden/'

#!/bin/bash

regex="href=\"[A-z]*"
baseUrl="http://10.11.200.193/.hidden/"
found=""

total=18279
current=0

searchFlag() {
    local url=$(echo "$1")
    # echo "$url"

    if [ ! -z "$found" -a "$found" != " " ]; then
        return
    fi

    local response=$(curl -s $url)

    # TEST IF FLAG IS HERE
    if [ "$2" == 1 ]; then
        local tmp=$(echo $response | grep -E "[0-9][0-9]+")

        if [ ! -z "$tmp" ]; then
            found=$(echo $tmp)
            return
        fi
    fi

    local array=($( echo $response | grep -o "$regex" | sed "s/href=\"//" | awk 'NF'))

    for i in "${array[@]}"
    do
        # echo $i
        if [ "$i" != "" -a "$i" != "README" ]; then
            searchFlag "$url$i/"
        elif [ "$i" != "" -a "$i" == "README" ]; then
            searchFlag "$url$i" 1
            current=$((current+1))
            echo -ne "Current progress : $(((current * 100) / total))%\r"
        fi
    done

}


searchFlag $baseUrl
echo ""
echo "THE FLAG IS : $found"