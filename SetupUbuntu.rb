##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.provision("setup-time", type: "shell",
                      path: "#{__dir__}/provision/setup-time.sh",
                      privileged: true)
end
