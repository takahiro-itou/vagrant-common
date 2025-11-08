##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

def provision_ram_disk(vm)
  vm.provision("ramdisk", type: "shell",
                path: "#{__dir__}/provision/ramdisk.sh",
                privileged: true)
end

Vagrant.configure("2") do |config|
  provision_ram_disk(config.vm)
end
