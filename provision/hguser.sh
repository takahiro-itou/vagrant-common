#! /bin/bash  -xue

echo  Provisioning  ${USER} for ${HOSTNAME}
test  -f  "${HOME}/.provision/hguser"  &&  exit 0

###
##  仮想マシン内に作成するユーザーのパスワード
###

user_pass='\$6\$F1IrDR2U\$'
user_pass+='gdsuepzT7noxUWaA5cpRjfAdhE5cS6qh0WhNBYm83ey'
user_pass+='PiZ0XbfrzuG6dGH3aezIQWn.vRf.aJsz1qD3RMi7yj0'

new_user='hg'
new_user_group='hg'

sudo  groupadd  "${new_user_group}"
userIndex=0

echo  "Initialize User: ${HOSTNAME}  ${new_user}"

# ユーザーを追加する。
new_user_add_opts="-g ${new_user_group}  -d /home/${new_user}  -s /bin/bash"
sudo  useradd  "${new_user_add_opts}"  -m "${new_user}"
eval  new_user_home="~${new_user}"

# ユーザーのパスワードを設定する。
new_passwd="${user_pass}"
sed_pat="^${new_user}:!:.*\$"
sed_rep="${new_user}:${new_passwd}:18294:0:99999:7:::"
sed_cmd="s|${sed_pat}|${sed_rep}|"
command="sudo  sed -i.bak  -e '${sed_cmd}'  /etc/shadow"
echo  "Execute: ${command}"
eval  ${command}

# 公開鍵を設定
pub_key_file="${HOME}/.ssh/Vagrant-Hg.8192.rsa.pub"
new_user_ssh="${new_user_home}/.ssh"
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
    sudo  chown  -R  "${new_user}:${new_user_group}"  "${new_user_ssh}"
fi

mkdir -p "${HOME}/.provision"
date  >  "${HOME}/.provision/hguser"
