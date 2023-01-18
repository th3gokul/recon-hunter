clear
mkdir ~/recon
echo "it will update and upgrade Your os"

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y python3-pip
sudo apt-get install -y git

echo "Installing Golang"

rm -rf /usr/local/go

wget https://dl.google.com/go/go1.19.5.linux-amd64.tar.gz

sudo rm -rf /usr/local/go
sudo tar -xvf go1.19.5.linux-amd64.tar.gz
sudo mv go /usr/local
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.zshrc
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc


go install github.com/tomnomnom/httprobe@latest
go install -v github.com/lukasikic/subzy@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/gf@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
sudo apt install -y eyewitness
sudo apt install -y dirsearch

cd ~/recon && git clone https://github.com/devanshbatham/ParamSpider.git && cd ParamSpider
pip3 install -r requirements.txt


sudo cd ~/go/bin
sudo cp assetfinder gf httprobe httpx subfinder waybackurls subzy /usr/bin
sudo cp gau /usr/bin/gau

mkdir ~/.gf
cd ~  && git clone https://github.com/1ndianl33t/Gf-Patterns.git
cp Gf-Patterns/*.json ~/.gf

mkdir ~/Desktop/output

echo " installation completed"
