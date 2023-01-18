clear
echo "it will update Your os"

sudo apt-get -y update
sleep 5
clear
echo "Do you want to upgarde your os (sudo apt-get -y upgrade)? (yes/no)"
read answer
if [ "$answer" == "yes" ]; then
    sudo apt-get -y upgrade
    echo "upgrade success"
else
    if [ "$answer" == "no" ]; then
        echo "Continuing with installing"
    else
        echo "Invalid input. Please type 'yes' or 'no'."
    fi
fi

sudo apt-get install -y python3-pip
sudo apt-get install -y git

clear

echo "Installing Golang"
sleep 5

# Check if golang is already installed
if go version 2>/dev/null; then
    echo "Golang is already installed. Proceeding to next step of program."
else
    echo "Golang is not installed. Installing Golang."
    rm -rf /usr/local/go
    wget https://dl.google.com/go/go1.19.5.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -xvf go1.19.5.linux-amd64.tar.gz
    sudo mv go /usr/local
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.zshrc
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

    echo "Golang installed successful"

fi


sleep 5
clear
echo "Now installing tools"
sleep 3

# Check if assetfinder is installed
if ! [ -x "$(command -v assetfinder)" ]; then
  echo 'Installing assetfinder...'
  go install github.com/tomnomnom/assetfinder@latest
  echo 'assetfinder has been installed.'
else
  echo 'assetfinder is already installed.'
fi

# Check if gf is installed
if ! [ -x "$(command -v gf)" ]; then
  echo 'Installing gf...'
  go install github.com/tomnomnom/gf@latest
  echo 'gf has been installed.'
else
  echo 'gf is already installed.'
fi

# Check if httprobe is installed
if ! [ -x "$(command -v httprobe)" ]; then
  echo 'Installing httprobe...'
  go install github.com/tomnomnom/httprobe@latest
  echo 'httprobe has been installed.'
else
  echo 'httprobe is already installed.'
fi

# Check if httpx is installed
if ! [ -x "$(command -v httpx)" ]; then
  echo 'Installing httpx...'
  go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
  echo 'httpx has been installed.'
else
  echo 'httpx is already installed.'
fi

# Check if subfinder is installed
if ! [ -x "$(command -v subfinder)" ]; then
  echo 'Installing subfinder...'
  go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
  echo 'subfinder has been installed.'
else
  echo 'subfinder is already installed.'
fi

# Check if waybackurls is installed
if ! [ -x "$(command -v waybackurls)" ]; then
  echo 'Installing waybackurls...'
  go install github.com/tomnomnom/waybackurls@latest
  echo 'waybackurls has been installed.'
else
  echo 'waybackurls is already installed.'
fi

# Check if subz is installed
if ! [ -x "$(command -v subzy)" ]; then
  echo 'Installing subz...'
  go install -v github.com/lukasikic/subzy@latest
  echo 'subz has been installed.'
else
  echo 'subz is already installed.'
fi

# Check if gau is installed

if ! [ -x "$(command -v gau)" ]; then
  echo 'Installing gau...'
  go install github.com/lc/gau/v2/cmd/gau@latest
  echo 'gau has been installed.'
else
  echo 'gau is already installed.'
fi

# Check if eyewitness is installed
if ! [ -x "$(command -v eyewitness)" ]; then
  echo 'Installing eyewitness...'
  apt-get install -y eyewitness
  echo 'eyewitness has been installed.'
else
  echo 'eyewitness is already installed.'
fi

mkdir ~/recon

cd ~/recon && git clone https://github.com/devanshbatham/ParamSpider.git && cd ParamSpider
pip3 install -r requirements.txt

sleep 3

clear
echo "configure the all tools plzz wait"

sleep 3

sudo cd ~/go/bin
sudo cp assetfinder gf httprobe httpx subfinder waybackurls subzy /usr/bin
sudo cp gau /usr/bin/gau

mkdir ~/.gf
cd ~  && git clone https://github.com/1ndianl33t/Gf-Patterns.git
cp Gf-Patterns/*.json ~/.gf

echo "checking all tools are installed"
sleep 3
TOOLS=(assetfinder gf httprobe httpx subfinder waybackurls subzy gau eyewitness)

tools_installed=true

for tool in "${TOOLS[@]}"
do
    if ! [ -x "$(command -v $tool)" ]; then
        echo "$tool is not installed"
        tools_installed=false
    else
        echo "$tool is already installed"
    fi
done

if [ "$tools_installed" = true ]; then
    echo "All tools are installed"
    echo "installation completed"
fi

