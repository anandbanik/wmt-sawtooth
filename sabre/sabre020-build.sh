#this script will pull sabre src from the git and build it.
sudo apt install -y  pkg-config
sudo apt install unzip

#rust install
curl https://sh.rustup.rs -sSf | sh -s -- -y

#protoc-3-5-1 library installation
curl -OLsS https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip
unzip protoc-3.5.1-linux-x86_64.zip -d protoc3
rm protoc-3.5.1-linux-x86_64.zip

#env for rust and protoc
PATH=$PATH:$HOME/protoc3/bin:$HOME/.cargo/bin

#pullinf rust from git
mkdir project
cd project
git clone https://github.com/hyperledger/sawtooth-sabre.git

#building sabre-tp and sabre-cli
cd sawtooth-sabre/cli
cargo build
cd ../tp
cargo build

#for the system md files 
mkdir /home/ubuntu/sabre-tp
cp /home/ubuntu/project/sawtooth-sabre/tp/target/debug/sawtooth-sabre /home/ubuntu/sabre-tp/

mkdir /home/ubuntu/sabre-cli
cp /home/ubuntu/project/sawtooth-sabre/cli/target/debug/sabre /home/ubuntu/sabre-cli/


