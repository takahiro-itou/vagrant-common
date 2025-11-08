##  -*-  coding: utf-8; mode: ruby -*-  ##
##  vi: set ft=ruby

load  File.expand_path('MachineInfo.rb', __dir__)

disk_file = $disk_image_file
puts "HDD : disk_file = #{disk_file}"

def check_disk_attached(machine, port: 'SCSI-2-0')
  if machine == '' then
    return  'none'
  end

  vm_info = `vboxmanage showvminfo #{machine} --machinereadable | grep #{port}`
  if vm_info == '' then
    return  'none'
  end

  value = (vm_info.split("=")[1].gsub('"','').chomp())
  p "check_disk_attached = #{value}"

  return  value
end

def detach_disk(machine, port: 2, device: 0)
  command = "VBoxManage storageattach #{machine}" +
            " --storagectl SCSI --port #{port} --device #{device}" +
            " --type hdd --medium none"
  p command
  `#{command}`
end


##################################################################
##
##    ディスクを追加する
##

def attach_scsi_hdd(v, disk_file)

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

def provision_newhdd_scsi(vm)

  vm.provision("newhdd", type: "shell",
                path: "#{__dir__}/provision/newhdd-scsi.sh",
                privileged: true)

end


##################################################################
##
##    仮想マシンを停止した時に、デタッチしておく
##

def config_detach_trigger(config)

  machine_id = MachineInfo.get_machine_id()

  config.trigger.after :halt do |trigger|
    trigger.ruby do |env, machine|
      puts "Detach disk from #{machine.id} after halt ..."
      detach_disk(machine.id)
    end
    trigger.info = 'Detach disk after halt'
  end

  config.trigger.before :destroy do |trigger|
    trigger.ruby do |env, machine|
      puts "Check disk attach in machine #{machine.id} ..."
      hdd_attached = check_disk_attached(machine_id, port: 'SCSI-2-0')

      if hdd_attached != 'none' then
        raise Vagrant::Errors::VagrantError.new, \
              "drive attached '#{hdd_attached}' - cannot be destroyed"
      end
    end
    trigger.info = 'Prevent destroy if HDD attached'
  end

end


Vagrant.configure("2") do |config|

  #
  # ディスクを追加する
  #
  config.vm.provider "virtualbox" do |v|
    attach_scsi_hdd(v, disk_file)
  end

  provision_newhdd_scsi(config.vm)

  #
  # 仮想マシンを停止した時に、デタッチしておく
  #
  config_detach_trigger(config)

end
