##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.provision("ramdisk", type: "shell",
                      path: "#{__dir__}/provision/ramdisk.sh",
                      privileged: true)
end
