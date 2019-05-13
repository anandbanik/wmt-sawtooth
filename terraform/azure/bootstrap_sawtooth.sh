#!/bin/bash

# Add the repo
if type sawtooth > /dev/null; then
    echo "Sawtooth installation detected!"
else
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD
    sudo add-apt-repository 'deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/stable xenial universe'
    sudo apt-get update
    # Install sawtooth
    sudo apt install -y sawtooth sawtooth-xo-tp-go python3-sawtooth-xo
    #Generate Keys
    sudo sawadm keygen
    sawtooth keygen
    #TODO: Get public key from /etc/sawtooth/keys/validator.pub to genesis node (@JasonWalker)
    #TODO: Configure sawtooth 
    sudo cp /etc/sawtooth/validator.toml.example /etc/sawtooth/validator.toml
    sudo chown $(id -u -n) /etc/sawtooth/validator.toml
fi

echo "Starting sawtooth services"
sudo systemctl start sawtooth-validator.service sawtooth-settings-tp.service sawtooth-rest-api.service sawtooth-pbft-engine.service sawtooth-xo-tp-go.service
