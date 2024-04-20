##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.provision("setup-centos", type: "shell",
                      path: "#{__dir__}/provision/setup-centos.sh",
                      privileged: true)
end
