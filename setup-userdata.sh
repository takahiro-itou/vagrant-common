#!/bin/bash  -xue

script_dir=$(dirname "$0")

project_base_dir=$(readlink -f "${script_dir}/..")
vagrant_dir="${project_base_dir}/vagrant"

workdir=${WORKDIR:-'/tmp'}

userfile_src_dir='data'
userfile_archive_file="${vagrant_dir}/data.tar.xz"

##
##  仮想マシンへ転送するディレクトリを用意する
##

rm -f "${userfile_archive_file}"

mkdir -p "${workdir}"
tempdir=$(mktemp -d "${workdir}/vagrant.XXXXXXXXXX")

conf_src_dir="${project_base_dir}/data"
conf_trg_dir="${tempdir}/${userfile_src_dir}"

# プロジェクト内の所定のディレクトリの内容を、
# 作成した作業用ディレクトリにコピーする。


rsync -a "${conf_src_dir}/" "${conf_trg_dir}/"

# プロジェクトの外にある所定のディレクトリも、
# 作業用ディレクトリにコピーする。

rsync -a ~/VagrantConfig/ "${conf_trg_dir}/home/vagrant/"

# 転送するディレクトリをアーカイブしておく

pushd "${tempdir}"
time  tar -cJf "${userfile_archive_file}" "${userfile_src_dir}/"
popd

# 不要になった作業ディレクトリを削除
rm -rf "${tempdir}"
