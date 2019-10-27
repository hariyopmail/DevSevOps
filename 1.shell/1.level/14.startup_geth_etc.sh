#!/bin/sh
##! /bin/sh
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is
nohup /usr/local/wallet/etc/geth_4.1.2_etc_28001 --fast --rpc=true --cache 1024 --rpcaddr 0.0.0.0 --rpcport 28001 --datadir "/usr/local/wallet/etc/data" --port 40316 --rpcapi "eth,net,web3,personal" >> /usr/local/wallet/etc/data/logs/geth.log 2>&1 &