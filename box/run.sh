#!/bin/bash

NC="\e[0m"           # no color
CYAN="\e[1m\e[1;96m" # cyan color

# Function to display the logo
function printLogo {
  echo -e '\033[1;96m'
  echo -e '  ██████╗  █████╗ ██████╗  █████╗            '
  echo -e '  ██╔══██╗██╔══██╗██╔══██╗██╔══██╗           '
  echo -e '  ██████╔╝███████║██████╔╝███████║           '
  echo -e '  ██╔═══╝ ██╔══██║██╔═══╝ ██╔══██║           '
  echo -e '  ██║     ██║  ██║██║     ██║  ██║           '
  echo -e '  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝           '
  echo -e '██████╗ ██████╗ ██╗████████╗████████╗ █████╗ '
  echo -e '██╔══██╗██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔══██╗'
  echo -e '██║  ██║██████╔╝██║   ██║      ██║   ███████║'
  echo -e '██║  ██║██╔══██╗██║   ██║      ██║   ██╔══██║'
  echo -e '██████╔╝██║  ██║██║   ██║      ██║   ██║  ██║'
  echo -e '╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝'
  echo -e '                                 @papadritta '
  echo -e '\e[0m'
  sleep 1
}

# Function to print a line of dashes
function printLine {
  echo "---------------------------------------------------------------------------------------"
}

# Function to print text in cyan color
function printCyan {
  echo -e "${CYAN}${1}${NC}"
}

# Function to check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to display an error message and exit
error_exit() {
  echo -e "\e[31mError: $1\e[0m"
  exit 1
}

# Function to delete previous versions of the script
delete_previous_version_1() {
    if [ -f "namada.sh" ]; then
        echo "Deleting previous version of namada.sh..."
        rm -f "namada.sh"
    fi
}

# Function to delete previous versions of the script
delete_previous_version_2() {
    if [ -f "swap8.sh" ]; then
        echo "Deleting previous version of swap8.sh..."
        rm -f "swap8.sh"
    fi
}

# Function to install a package if it's not already installed
install_if_not_exists() {
  if ! exists "$1"; then
    sudo apt update && sudo apt install "$1" -y < "/dev/null" || error_exit "Failed to install $1"
  fi
}

# Function to prompt for user input if a variable is not set
prompt_if_not_set() {
  if [ -z "${!1}" ]; then
    read -p "Enter $2: " "$1"
    echo "export $1=\"${!1}\"" >>"$HOME/.bash_profile"
  fi
}

# Print the logo
printLogo

# Print a line of dashes
printLine

## Update packages before installation
apt-get update

printCyan "Checking and Installing dependencies..." && sleep 1
# Check for required dependencies and install if missing
install_if_not_exists "curl"
install_if_not_exists "make"
install_if_not_exists "unzip"
install_if_not_exists "clang"
install_if_not_exists "pkg-config"
install_if_not_exists "git-core"
install_if_not_exists "libudev-dev"
install_if_not_exists "libssl-dev"
install_if_not_exists "build-essential"
install_if_not_exists "libclang-12-dev"
install_if_not_exists "git"
install_if_not_exists "jq"
install_if_not_exists "ncdu"
install_if_not_exists "bsdmainutils"
install_if_not_exists "htop"

# Print a line of dashes
printLine

# Check for and delete previous versions of the scripts
delete_previous_version_1
delete_previous_version_2

# Check for and install Rust
printCyan "Installing Rust..." && sleep 1

if ! exists "rustup"; then
    echo -e '\n\e[42mInstall Rust\e[0m\n' && sleep 1
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env" || error_exit "Failed to set up Rust environment"
else
    echo "Rust is already installed"
fi

# Print a line of dashes
printLine

# Check for and install Protocol Buffers
printCyan "Installing Protocol Buffers..." && sleep 1

if ! exists "protoc" || [ "$(protoc --version | awk '{print $NF}')" != "3.12.0" ]; then
    echo -e '\n\e[42mInstall libprotoc 3.12.0\e[0m\n' && sleep 1
    curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.12.0/protoc-3.12.0-linux-x86_64.zip
    unzip -o protoc-3.12.0-linux-x86_64.zip -d "$HOME/.local"
    echo 'export PATH=$PATH:'"$HOME/.local/bin" >>"$HOME/.bash_profile"
    source "$HOME/.bash_profile" || error_exit "Failed to set up Protocol Buffers"
else
    echo "Protocol Buffers 3.12.0 is already installed"
fi

# Print a line of dashes
printLine

# Check for and install Go
printCyan "Installing Go..." && sleep 1

if ! exists "go"; then
    echo -e '\n\e[42mInstall Go\e[0m\n' && sleep 1
    VERSION="1.20.5"
    wget -O go.tar.gz "https://go.dev/dl/go$VERSION.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
    echo 'export GOROOT=/usr/local/go' >>"$HOME/.bash_profile"
    echo 'export GOPATH=$HOME/go' >>"$HOME/.bash_profile"
    echo 'export GO111MODULE=on' >>"$HOME/.bash_profile"
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >>"$HOME/.bash_profile" && source "$HOME/.bash_profile"
    go version || error_exit "Failed to set up Go"
else
    echo "Go is already installed"
fi

# Print a line of dashes
printLine

# Create a directory for binaries
# Download and install CometBFT
printCyan "Create a dir & Installing CometBFT..." && sleep 1

mkdir -p "$HOME/cometbft_bin"
cd "$HOME/cometbft_bin"

if ! exists "cometbft"; then
    echo -e '\n\e[42mInstall CometBFT\e[0m\n' && sleep 1
    wget -O cometbft.tar.gz "https://github.com/cometbft/cometbft/releases/download/v0.37.2/cometbft_0.37.2_linux_amd64.tar.gz"
    tar xvf cometbft.tar.gz
    sudo chmod +x cometbft
    sudo mv ./cometbft /usr/local/bin/ || error_exit "Failed to install CometBFT"
else
    echo "CometBFT is already installed"
fi

# Print a line of dashes
printLine

# Clone Namada repository
# Checkout the desired Namada version
printCyan "Clone Namada repo & Check Namada version..." && sleep 1

cd "$HOME"
if [ ! -d "namada" ]; then
    echo -e '\n\e[42mClone Namada repository\e[0m\n' && sleep 1
    git clone https://github.com/anoma/namada || error_exit "Failed to clone Namada repository"
fi

cd "$HOME/namada"
git checkout "$NAMADA_TAG"

# Build and install Namada
printCyan "Build and install Namada..." && sleep 1

echo -e '\n\e[42mBuild and install Namada\e[0m\n' && sleep 1
make build-release || error_exit "Failed to build Namada"
sudo mv target/release/namada /usr/local/bin/ || error_exit "Failed to install Namada"
sudo mv target/release/namada[c,n,w] /usr/local/bin/ || error_exit "Failed to install Namada"
cd "$HOME"

# Print a line of dashes
printLine

# Set up environment variables and configuration
printCyan "Set up environment..." && sleep 1

# Prompt for user input
read -p "Enter validator name: " VALIDATOR_ALIAS
read -p "Enter your email address: " EMAIL
read -p "Enter your Discord name: " DISCORD

# Add user inputs to .bash_profile
echo 'export VALIDATOR_ALIAS='"${VALIDATOR_ALIAS}"'' >> "$HOME/.bash_profile"
echo 'export EMAIL='"${EMAIL}"'' >> "$HOME/.bash_profile"
echo 'export DISCORD='"${DISCORD}"'' >> "$HOME/.bash_profile"

# Display confirmation message
echo -e "Validator name: ${CYAN}${VALIDATOR_ALIAS}${NC}"
echo -e "Email address: ${CYAN}${EMAIL}${NC}"
echo -e "Discord name: ${CYAN}${DISCORD}${NC}"

# Print a line of dashes
printLine

# Add necessary environment variables and configuration to .bash_profile
echo 'source $HOME/.bashrc' >>"$HOME/.bash_profile"
. "$HOME/.bash_profile"

# Update system and dependencies
sudo apt update
sudo apt install -y libssl1.1

# Create a systemd service for Namada
echo -e '\n\e[42mCreate a systemd service for Namada\e[0m\n' && sleep 1
echo "[Unit]
Description=Namada Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/.local/share/namada
Type=simple
ExecStart=/usr/local/bin/namadan ledger run
Environment=NAMADA_LOG=info
Environment=NAMADA_CMT_STDOUT=true
Environment=CMT_LOG_LEVEL=p2p:none,pex:error
LimitSTACK=unlimited
RemainAfterExit=no
Restart=always
RestartSec=5s
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/namadad.service
sudo mv $HOME/namadad.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl restart namadad

printCyan "Check NAMADA status..." && sleep 1

if [[ `service namadad status | grep active` =~ "running" ]]; then
    echo -e "Your namada node \e[32minstalled and works\e[39m!"
    echo -e "You can check node status by the command \e[7msudo systemctl status namadad\e[0m"
    echo -e "Press \e[7mQ\e[0m for exit from status menu"
    echo -e "You can check logs by the command \e[7m. sudo journalctl -n 100 -f -u namadad\e[0m"
else
    echo -e "Your namada node \e[31mwas not installed correctly\e[39m, please reinstall."
fi

# Print a line of dashes
printLine
