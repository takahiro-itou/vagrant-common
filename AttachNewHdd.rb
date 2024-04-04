##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

load  File.expand_path('MachineInfo.rb', __dir__)

machine_id = MachineInfo.get_machine_id()
disk_file = $disk_image_file

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |v|
    #
    # ディスクを追加する
    #
    unless File.exists?(disk_file)
      v.customize [
        'createmedium',     'disk',
        '--filename',       disk_file,
        '--size',           50 * 1024,
        '--format',         'VDI',
      ]
    end

    if ARGV.include?('destroy')
    else
      v.customize [
        'storageattach',    :id,
        '--storagectl',     'SCSI',
        '--port',           2,
        '--device',         0,
        '--type',           'hdd',
        '--medium',         disk_file,
      ]
    end
  end

  config.vm.provision("newhdd", type: "shell",
                      path: "#{__dir__}/provision.newhdd.sh",
                      privileged: true)
  #
  # 仮想マシンを停止した時に、デタッチしておく
  #
  config.trigger.after :halt do |trigger|
    trigger.run = {inline: "VBoxManage storageattach '#{machine_id}'" +
      " --storagectl 'SCSI' --port 2 --device 0 --type hdd --medium none"
    }
  end

end
