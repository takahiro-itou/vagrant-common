##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.provision("userfiles1", type: "file",
                      source: "data.tar.xz",
                      destination: "/tmp/")
  config.vm.provision("userfiles2", type: "shell",
                      path: "common/provision.data.sh",
                      privileged: false)
end
