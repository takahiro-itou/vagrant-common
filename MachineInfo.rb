
module  MachineInfo

    MACHINE_ID_FILE ='.vagrant/machines/default/virtualbox/id'

    def  machine_id_file
        return  MACHINE_ID_FILE
    end

    def  get_machine_id
        machine_id = ''
        if File.exists?(MACHINE_ID_FILE)
            machine_id = File.read(MACHINE_ID_FILE)
        end
        return  machine_id
    end

    module_function :get_machine_id
end
