#!/bin/bash  -x

set  -ue

machine=$1
name=${2:-'SCSI'}
maxport=${3:-'16'}


function  add_scsi_ctl::enumerate_storage_controllers () {

VBoxManage  \
    showvminfo "${machine}"  --machinereadable  | \
    grep  storagecontrollername

}

function  add_scsi_ctl::main () {

if [[ add_scsi_ctl::enumerate_storage_controllers | grep "${name}" ]] ; then
    # 既にコントローラが存在するので無視
    echo  "Controller ${name} already exists. SKIP."  1>&2
    exit  0
fi

VBoxManage  \
    storagectl      "${machine}"    \
    --name          "${name}"       \
    --add           scsi            \
    --controller    LSILogic        \
    --portcount     "${maxport}"    \
    --bootable      on              \
;

}


add_scsi_ctl::main
