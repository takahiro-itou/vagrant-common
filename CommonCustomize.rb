##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

def customize_config(config)
  config.vm.box_download_options = {"ssl-revoke-best-effort" => true}
  config.vm.boot_timeout = 900
end


def customize_vm_provider(vm)

  vm.customize [
    "modifyvm",           :id,
    "--cableconnected1",  "on",
    "--hwvirtex",         "on",
    "--nestedpaging",     "on",
    "--largepages",       "on",
    "--ioapic",           "on",
    "--pae",              "on",
    "--paravirtprovider", "kvm",
  ]

  #
  # 時刻をホスト側と同期する
  #
  vm.customize [
    'setextradata',     :id,
    'VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled',
    0
  ]

end

##
##  Usage
##
##  ```
##  Vagrant.configure("2") do |config|
##    customize_config(config)
##
##    config.vm.provider "virtualbox" do |v|
##      customize_vm_provider(v)
##    end
##  end
##  ```
##
