#this script will only run in genesis node. 
#stop if the service is running
rm ~/infra.log
echo -e "\033[31mStopping services\033[39m" > ~/infra.log
sudo systemctl stop \
sawtooth-validator.service \
sawtooth-settings-tp.service \
sawtooth-rest-api.service \
sawtooth-pbft-engine.service \
sawtooth-xo-tp-go.service \
sawtooth-intkey-tp-python.service \
sawtooth-sabre020.service \

echo $(sudo systemctl status sawtooth-validator.service sawtooth-settings-tp.service sawtooth-rest-api.service sawtooth-pbft-engine.service sawtooth-xo-tp-go.service ) >> ~/infra.log


echo -e "\033[31mRemoving blockdata\033[39m" >> ~/infra.log
#remove existing network data

#remove existing network data
sudo rm /var/lib/sawtooth/block-00.lmdb \
/var/lib/sawtooth/merkle-00.lmdb \
/var/lib/sawtooth/txn_receipts-00.lmdb-lock \
/var/lib/sawtooth/block-00.lmdb-lock \
/var/lib/sawtooth/merkle-00.lmdb-lock \
/var/lib/sawtooth/block-chain-id \
/var/lib/sawtooth/txn_receipts-00.lmdb


echo -e "\033[32mlib data: \033[39m" >> ~/infra.log
echo "$(sudo ls /var/lib/sawtooth/)" >> ~/infra.log

#create the genesis batch
sudo sawset genesis -k /etc/sawtooth/keys/validator.priv -o config-genesis.batch

#create initial pbft config batch
sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
sawtooth.consensus.algorithm.name=pbft \
sawtooth.consensus.algorithm.version=0.1 \
sawtooth.consensus.pbft.peers=['"'$(paste /home/ubuntu/*.pub -d , | sed s/,/\",\"/g)'"'] \
sawtooth.consensus.pbft.view_change_timeout=4000 \
sawtooth.consensus.pbft.message_timeout=10 \
sawtooth.consensus.pbft.max_log_size=1000 \
sawtooth.swa.administrators=$(cat /home/ubuntu/.sawtooth/keys/ubuntu.pub) \
-o config.batch

#create the genesis block using above 2 batches
sudo -u sawtooth sawadm genesis config-genesis.batch config.batch

#start the ngenisis node 
sudo systemctl start \
sawtooth-validator.service \
sawtooth-settings-tp.service \
sawtooth-rest-api.service \
sawtooth-pbft-engine.service \
sawtooth-xo-tp-go.service \
sawtooth-intkey-tp-python.service \
sawtooth-sabre020.service \

echo -e "\033[32mStarting services\033[39m" >> ~/infra.log
echo $(sudo systemctl status sawtooth-validator.service sawtooth-settings-tp.service sawtooth-rest-api.service sawtooth-pbft-engine.service sawtooth-xo-tp-go.service ) >> ~/infra.log
