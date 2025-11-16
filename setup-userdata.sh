#!/bin/bash  -xue

script_dir=$(dirname "$0")

project_base_default=$(readlink -f "${script_dir}/../..")

project_base_dir=${PROJECT_BASE_DIR:-"${project_base_default}"}
workdir=${WORKDIR:-'/tmp'}

vagrant_dir="${project_base_dir}/vagrant"

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

# 所定の場所にプロジェクト固有のシェルスクリプトが
# 存在する場合は、そのスクリプトも実行する。

target_script="${vagrant_dir}/archive-data.sh"
if [[ -x "${target_script}" ]] ; then
    "${target_script}"  "${conf_trg_dir}"  "${project_base_dir}"
fi

# プロジェクトの外にある所定のディレクトリも、
# 作業用ディレクトリにコピーする。

copy_config_dir=${COPY_CONFIG_DIR:-'no'}
if [[ "X${copy_config_dir}Y" = 'XyesY' ]] ; then
    rsync -a ~/VagrantConfig/ "${conf_trg_dir}/home/vagrant/"
fi

for dir in "$@" ; do
    rsync -a "${dir}" "${conf_trg_dir}/home/vagrant/"
done

# 転送するディレクトリをアーカイブしておく

pushd "${tempdir}"
time  tar -cJf "${userfile_archive_file}" "${userfile_src_dir}/"
popd

# 不要になった作業ディレクトリを削除
rm -rf "${tempdir}"
