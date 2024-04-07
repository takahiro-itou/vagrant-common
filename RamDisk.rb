##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.provision("newhdd", type: "shell",
                      path: "#{__dir__}/provision/newhdd.sh",
                      privileged: true)
end
