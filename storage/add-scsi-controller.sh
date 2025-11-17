#!/bin/bash  -x

set  -ue

machine=$1
name=${2:-'SCSI'}
maxport=${3:-'16'}

VBoxManage  \
    storagectl      "${machine}"    \
    --name          "${name}"       \
    --add           scsi            \
    --controller    LSILogic        \
    --portcount     "${maxport}"    \
    --bootable      on              \
;
