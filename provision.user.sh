#!/bin/bash  -xue

echo  "Provisioning  ${USER} for ${HOSTNAME}"
test  -f  "${HOME}/.provision.user"  &&  exit 0

for src_dir in  /tmp/data/home/vagrant  ; do
    if  test -d ${src_dir} ; then
        chmod  -R   go-rwx  ${src_dir}
        rsync  -a   ${src_dir}/  ${HOME}/
    fi
done

if  test -d ${HOME}/.ssh ; then
    chmod  -R   go-rwx  ${HOME}/.ssh/
    chmod  700  ${HOME}/.ssh
fi

date  >  "${HOME}/.provision.user"
