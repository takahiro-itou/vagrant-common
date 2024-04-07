##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.provision("user", type: "shell",
                      path: "#{__dir__}/provision/user.sh",
                      privileged: false)
  config.vm.provision("hguser", type: "shell",
                      path: "#{__dir__}/provision/hguser.sh",
                      privileged: false)
end
