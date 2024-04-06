#!/bin/bash  -xue

machine_id=$1
port=$2
device=$3

VBoxManage storageattach "${machine_id}"  \
     --storagectl 'SCSI' --port "${port}" --device "${device}"  \
     --type hdd --medium none
