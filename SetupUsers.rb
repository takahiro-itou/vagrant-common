##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

def provision_setup_users(vm)
  vm.provision("user", type: "shell",
                path: "#{__dir__}/provision/user.sh",
                privileged: false)
  vm.provision("hguser", type: "shell",
                path: "#{__dir__}/provision/hguser.sh",
                privileged: false)
end

Vagrant.configure("2") do |config|
  provision_setup_users(config.vm)
end
