#! /bin/bash  -xue

echo  Provisioning  ${USER} for ${HOSTNAME}
test  -f  ${HOME}/.provision.hguser  &&  exit 0

###
##  仮想マシン内に作成するユーザーのパスワード
###

userPass='\$6\$F1IrDR2U\$'
userPass+='gdsuepzT7noxUWaA5cpRjfAdhE5cS6qh0WhNBYm83ey'
userPass+='PiZ0XbfrzuG6dGH3aezIQWn.vRf.aJsz1qD3RMi7yj0'

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
newPasswd=${userPass}
sedPat="^${newUser}:!:.*\$"
sedRep="${newUser}:${newPasswd}:18294:0:99999:7:::"
sedCmd="s|${sedPat}|${sedRep}|"
command="sudo  sed -i.bak  -e '${sedCmd}'  /etc/shadow"
echo  "Execute: ${command}"
eval  ${command}

# 公開鍵を設定
pubKeyFile=${HOME}/.ssh/Vagrant-Hg.8192.rsa.pub
newUserSSH=${newUserHome}/.ssh
newUserAuth=${newUserSSH}/authorized_keys

sudo  mkdir  ${newUserSSH}

if test -f ${pubKeyFile} ; then
    cat  ${pubKeyFile} | sudo tee -a  ${newUserAuth}
fi

sudo  chmod  0600  ${newUserAuth}
sudo  chmod  0700  ${newUserSSH}
sudo  chown  -R  ${newUser}:${newUserGroup}  ${newUserSSH}

date  >  ${HOME}/.provision.hguser
