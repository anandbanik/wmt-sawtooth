# Terraform Script for provisioning Ubuntu with Sawtooth installed

## Steps

1. Create a file called "terraform.tfvars" and make sure it has "subscription_id", "client_id", "client_secret", ,"tenant_id".
   Also add your public key to access the VM
   For the rest, you can use the default values in "variables.tf"

2. Initiate the terraform script with the below command
    ```bash
    terraform init
    ```
3. Create a plan for terraform execution with the below command
    ```bash
    terraform plan
    ```
4. Review the above plan and if looks good, go ahead and execute the script.
    ```bash
    terraform apply
    ```

## Installing Sawtooth and creating a network

### For all nodes.

1. Execute the below commands to add sawtooth repository
```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD

sudo add-apt-repository 'deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/stable xenial universe'

sudo apt-get update
```
2. Install sawtooth, sawtooth pbft engine and xo transaction processor.
```bash
sudo apt install -y --allow-unauthenticated sawtooth sawtooth-pbft-engine sawtooth-xo-tp-go python3-sawtooth-xo
```

3. Generate user keys and admin keys
```bash
sudo sawadm keygen

sawtooth keygen

cp /etc/sawtooth/keys/validator.pub ~/$(hostname).pub
```

### On the Genesis node

1. Copy all the peer public key (including genesis node) in the home directory.

2. Create the genesis config with the below command.
```bash
sudo sawset genesis --key /etc/sawtooth/keys/validator.priv -o config-genesis.batch
```

3. Create the genesis block with the below command.
```bash
sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
sawtooth.consensus.algorithm.name=pbft \
sawtooth.consensus.algorithm.version=0.1 \
sawtooth.consensus.pbft.peers=['"'$(paste ~/*.pub -d , | sed s/,/\",\"/g)'"'] \
sawtooth.consensus.pbft.view_change_timeout=10000 \
sawtooth.consensus.pbft.message_timeout=10 \
sawtooth.consensus.pbft.max_log_size=1000 \
-o config.batch
```

Note: For running Sabre contracts, add the below.
```bash
sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
sawtooth.swa.administrators=$(cat ~/.sawtooth/keys/sawtooth.pub)
```

4. Create the genesis block
```bash
sudo -u sawtooth sawadm genesis config-genesis.batch config.batch
```

5. Create the network public and private keys using python 3.<br>
```bash
>>> import zmq
>>> (public, secret) = zmq.curve_keypair()

>>> print (public)


>>> print (secret)
```
remove the 'b' prefix and make a copy of the keys.<br>

### Create the below validator config.

1. Create the validator.toml file and make the current user (sawtooth) the owner.<br>
```bash
sudo cp /etc/sawtooth/validator.toml.example /etc/sawtooth/validator.toml
sudo chown sawtooth /etc/sawtooth/validator.toml
sudo vim /etc/sawtooth/validator.toml
```

2. Locate the bind settings in this file. Change the network line to the IP address or name of the
network interface that the validator ( sawtooth-validator ) should listen on. Leave the rest as
127.0.0.1 . For example:<br>
```bash
bind = [
"network:tcp://0.0.0.0:8800",
"component:tcp://127.0.0.1:4004",
"consensus:tcp://127.0.0.1:5050"
]
```

3. Change endpoint to the external address that other nodes will use to connect to this validator.
In this case, use the elastic IP address. For example:<br>
```bash
endpoint = "tcp://3.210.182.215:8800"
```

4. Uncomment the peers setting and add each peer IP address, in comma-separated list. (A PBFT network must be fully peered.) For example:
```bash
peers = ["tcp://3.210.182.215:8800", "tcp://34.205.254.204:8800",
"tcp://34.226.82.148:8800"]
```

5. Locate the scheduler setting and enable the parallel scheduler:<br>
```bash
scheduler = 'parallel'
```

6. Locate the network_public_key and network_private_key settings. Change the default keys to the ones generated on the genesis node.<br>
IMPORTANT : Each node must use the network key pair that was created on the genesis
```bash
network_public_key = ' public_key '
network_private_key = ' secret_key '
```

### On all nodes : Start Sawtooth

1. First, start Sawtooth on the genesis node:
```bash
sudo systemctl start sawtooth-validator.service sawtooth-settings-tp.service sawtooth-rest-api.service sawtooth-pbft-engine.service sawtooth-xo-tp-go.service
```

2. Wait for 3 mins.

3. Now, start the Sawtooth on all peer nodes
```bash
sudo systemctl start sawtooth-validator.service sawtooth-settings-tp.service sawtooth-rest-api.service sawtooth-pbft-engine.service sawtooth-xo-tp-go.service
```

### Logs

1. Sys logs
```bash
tail -400f /var/log/syslog
```

2. Validator log
```bash
tail -400f /var/log/sawtooth/validator-debug.log
```