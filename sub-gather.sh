#!/bin/bash

folder=$1
target=$2




echo "Starting.............."

mkdir $folder


subdomain_enum() {
    cd Sublist3r 
    python3 sublist3r.py -d $target -o ~/$folder/subs.txt > /dev/null
    cd ~/$folder
    count=$(wc -l < subs.txt)
    echo "$count subdomains has been collected"
    assetfinder --subs-only $target >> subs.txt
    count=$(wc -l < subs.txt)
    echo "$count subdomains has been collected"
    subfinder -d $target -o subs2.txt > /dev/null
    findomain -t $target -u subs3.txt > /dev/null
    cat subs2.txt subs3.txt >> subs.txt
    rm subs2.txt subs3.txt
    count=$(wc -l < subs.txt)
    echo "$count subdomains has been collected"
}
subdomain_enum

check_edit() {

    echo "looking for live subdomains"
    cat subs.txt | sort -u > new.txt
    cat new.txt | httprobe > live.txt
    rm subs.txt
    rm new.txt
    end=$(wc -l < live.txt)
    echo "$end live Subdomain was found!!"
    
}
check_edit


extract_ips() {

    echo "Extract IPs"
    for domain in $(cat live.txt | cut -d "/" -f 3 | tee subdomains-live.txt)
    do
    host $domain | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' >> ips.txt
    cat ips.txt | sort -u >> IPs.txt
    rm ips.txt
    done
    cat subdomains-live.txt | httpx -o urls-live.txt > /dev/null
}

extract_ips


