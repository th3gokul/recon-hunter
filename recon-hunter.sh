TOOLS=(assetfinder gf httprobe httpx subfinder waybackurls subzy gau eyewitness)

for tool in "${TOOLS[@]}"
do
    if ! command -v "$tool" > /dev/null 2>&1; then
        echo "$tool is not installed"
        exit 1
    else
        echo "$tool is already installed"
    fi
done

echo "All tools are installed. Continuing with program..."
sleep 4
clear

#!/bin/bash

if [ ! -d ~/Desktop/output ]; then
  mkdir ~/Desktop/output
  echo "Output folder created in Desktop. Continuing with program..."
else
  echo "Output folder already exists in Desktop. Continuing with program..."
fi

clear

# Get the target domain and company name

echo -n "Enter the target domain: "
read domain
echo -n "Enter the company name: "
read company

# Create a new folder with the company name
mkdir ~/Desktop/output/$company

while true; do
    echo -en "\n1 for subdomain & httpx & httprobe & screenshot &subzy\n2 for gau & waybackurl & gf\n3 for exit\nenter:" 
    read input
    if [ "$input" == "1" ]; then
        echo "Executing program 1"
        
        sleep 3

        mkdir ~/Desktop/output/$company/result1

        # Move into the new folder
        cd ~/Desktop/output/$company/result1


        # Use subfinder to find subdomains
        subfinder -d $domain > ~/Desktop/output/$company/result1/subfinder.txt

        clear

        echo "starting assetfinder"

        # Use assetfinder to find subdomains
        assetfinder --subs-only $domain > ~/Desktop/output/$company/result1/assetfinder.txt

        echo "---assentfinder----finished----"
        sleep 2

        clear

        echo "Remove Duplicates string and merge output"



        cd ~/Desktop/output/$company/result1

        # Remove duplicates
        sort -u subfinder.txt -o subfinder.txt
        sort -u assetfinder.txt -o assetfinder.txt

        # Concatenate results and save to all-subdomains.txt
        cat subfinder.txt assetfinder.txt | sort -u > all-subdomains.txt

        sleep 2

        clear

        echo "-------httpx---starting---------"

        sleep 3

        # Use httpx to check status code
        cat all-subdomains.txt | httpx -silent -status-code | tee status-code.txt

        sleep 3

        clear

        echo "------httprobe----starting-----"


        # Use httprobe to find live subdomains
        cat all-subdomains.txt | httprobe -c 50 -t 2000 | tee -a all-live-subdomains.txt

        sleep 3

        clear


        echo "extract https and http subdomains to live-http.txt"
        sleep 3
 

        # Use grep to extract https and http subdomains
        grep "http" all-live-subdomains.txt > live-http.txt


        #subzy subdomain takeover

        subzy run --targets all-subdomains.txt | tee subdomain-takeover.txt

        read -p "Do you want to proceed? (yes/no) " yn
        case $yn in 
            yes ) echo "starting eyewitness" ;
                sleep 3;
                eyewitness -f all-subdomains.txt -d eyewitness;;
            no ) echo exiting...;;
            * ) echo invalid response;
        esac

        echo "continue with program"  

    elif [ "$input" == "2" ]; then
        echo "Executing program 2"

        clear


        mkdir ~/Desktop/output/$company/result2
        cd ~/Desktop/output/$company/result2

        #gau

        echo "-----gau ------- starting----"

        gau $domain | tee ~/Desktop/output/$company/result2/$company-gau.txt
        echo "finish gau"

        clear

        #waybackurls

        echo "-------waybackurls-----staring------"

        waybackurls $domain | tee ~/Desktop/output/$company/result2/$company-waybackurls.txt
        echo "finish waybackurls"
        clear

        cd ~/Desktop/output/$company/result2

        sort -u $company-gau.txt -o $company-gau.txt
        sort -u $company-waybackurls.txt -o $company-waybackurls.txt

        cat $company-gau.txt $company-waybackurls.txt > all-url-gau-waybackurls.txt


        echo "------paramspider--is---Loading-------"

        sleep 3

        echo "------Paramspider start-----------"

        cd ~/Recon/ParamSpider/ && python3 paramspider.py --domain $domain | tee ~/Desktop/output/$company/result2/$company-paramspider.txt

        echo "-----extracting paramspider result to http only -> http-paramspider.txt"
        sleep 2

        grep "http" ~/Desktop/output/$company/result2/$company-paramspider.txt > ~/Desktop/output/$company/result2/http-$company-paramspider.txt

        mkdir ~/Desktop/output/$company/result2/gf-outputs
        mkdir ~/Desktop/output/$company/result2/gf-outputs/gf-paramspider

        echo "----gf----loading----using----paramspider----output-file----"

        sleep 2

        echo "-----start----gf----xss"

    

        gf xss ~/Desktop/output/$company/result2/$company-paramspider.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-paramspider/xss-gf.txt

        sleep 3

        clear

        echo "-----start----gf----redirect"

      

        gf redirect ~/Desktop/output/$company/result2/$company-paramspider.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-paramspider/redirect-gf.txt
        sleep 3

        clear

        echo "-----start----gf----sqli"

    

        gf sqli ~/Desktop/output/$company/result2/$company-paramspider.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-paramspider/sqli-gf.txt
        sleep 3

        clear


        echo "-----start----gf----idor"

        gf idor ~/Desktop/output/$company/result2/$company-paramspider.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-paramspider/sqli-gf.txt
        sleep 3

        clear

        mkdir ~/Desktop/output/$company/result2/gf-outputs/gf-gau-waybackurl

        clear


        echo "---gf------loading---using--gau and waybackurl--output-file---"

        sleep 4

        echo "-----start----gf----xss"

        gf xss ~/Desktop/output/$company/result2/all-url-gau-waybackurls.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-gau-waybackurl/xss-gf.txt
        sleep 3
        clear

        echo "-----start----gf----redirect"

        gf redirect ~/Desktop/output/$company/result2/all-url-gau-waybackurls.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-gau-waybackurl/redirect-gf.txt
        sleep 3
        clear

        echo "-----start----gf----sqli"

        gf sqli ~/Desktop/output/$company/result2/all-url-gau-waybackurls.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-gau-waybackurl/sqli-gf.txt
        sleep 3
        clear


        echo "-----start----gf----idor"

        gf idor ~/Desktop/output/$company/result2/all-url-gau-waybackurls.txt | tee ~/Desktop/output/$company/result2/gf-outputs/gf-gau-waybackurl/sqli-gf.txt
        sleep 3
        clear
        echo "Finished"

        

    elif [ "$input" == "3" ]; then
        echo "Exiting program"
        exit 0
    else
        echo "Invalid input"
    fi
done



