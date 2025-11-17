#!/bin/bash  -x

set  -ue

machine=$1
port=$2
device=$3

VBoxManage  \
    storageattach   "${machine}"      \
    --storagectl    'IDE Controller'  \
    --port          "${port}"         \
    --device        "${device}"       \
    --type          hdd               \
    --medium        none              \
;
