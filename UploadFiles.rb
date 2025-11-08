##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

def provision_upload_files(vm)

  vm.provision("userfiles1", type: "file",
                source: "data.tar.xz",
                destination: "/tmp/")
  vm.provision("userfiles2", type: "shell",
                path: "common/provision/data.sh",
                privileged: false)

end

Vagrant.configure("2") do |config|
  provision_upload_files(config.vm)
end
