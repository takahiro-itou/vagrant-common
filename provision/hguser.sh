#! /bin/bash  -xue

echo  Provisioning  ${USER} for ${HOSTNAME}
test  -f  "${HOME}/.provision/hguser"  &&  exit 0

###
##  仮想マシン内に作成するユーザーのパスワード
###

user_pass='\$6\$F1IrDR2U\$'
user_pass+='gdsuepzT7noxUWaA5cpRjfAdhE5cS6qh0WhNBYm83ey'
user_pass+='PiZ0XbfrzuG6dGH3aezIQWn.vRf.aJsz1qD3RMi7yj0'

newUser=hg
newUserGroup=hg

sudo  groupadd  ${newUserGroup}
userIndex=0

echo  "Initialize User: ${HOSTNAME}  ${newUser}"

# ユーザーを追加する。
newUserAddOpts="-g ${newUserGroup}  -d /home/${newUser}  -s /bin/bash"
sudo  useradd  ${newUserAddOpts}  -m  ${newUser}
eval  newUserHome=~${newUser}

# ユーザーのパスワードを設定する。
newPasswd=${user_pass}
sedPat="^${newUser}:!:.*\$"
sedRep="${newUser}:${newPasswd}:18294:0:99999:7:::"
sedCmd="s|${sedPat}|${sedRep}|"
command="sudo  sed -i.bak  -e '${sedCmd}'  /etc/shadow"
echo  "Execute: ${command}"
eval  ${command}

# 公開鍵を設定
pub_key_file="${HOME}/.ssh/Vagrant-Hg.8192.rsa.pub"
new_user_ssh=${newUserHome}/.ssh
new_user_auth="${new_user_ssh}/authorized_keys"

sudo  mkdir -p "${new_user_ssh}"

if [[ -f "${pub_key_file}" ]] ; then
    cat  "${pub_key_file}" | sudo  tee -a "${new_user_auth}"
fi

if [[ -f "${new_user_auth}" ]] ; then
    sudo  chmod  0600  "${new_user_auth}"
fi
if [[ -d "${new_user_ssh}" ]] ; then
    sudo  chmod  0700  "${new_user_ssh}"
    sudo  chown  -R  ${newUser}:${newUserGroup}  ${new_user_ssh}
fi

mkdir -p "${HOME}/.provision"
date  >  "${HOME}/.provision/hguser"
