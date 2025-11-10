##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

def provision_setup_centos(vm)
  vm.provision("setup-centos", type: "shell",
                path: "#{__dir__}/provision/setup-centos.sh",
                privileged: true)
end
