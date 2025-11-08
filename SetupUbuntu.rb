##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

def provision_setup_ubuntu(vm)
  vm.provision("setup-time", type: "shell",
                path: "#{__dir__}/provision/setup-time.sh",
                privileged: true)
end

Vagrant.configure("2") do |config|
  provision_setup_ubuntu(config.vm)
end
