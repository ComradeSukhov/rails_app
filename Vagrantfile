HOSTS = {
  'vm-1' => { ip: '10.10.1.5',  memory: 4096, cpus: 2 }
}

Vagrant.configure('2') do |config|
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

  HOSTS.each do |name, params|
    config.vm.define name.to_s do |srv|
      srv.vm.box = 'ubuntu/bionic64'
      srv.vm.network 'private_network', ip: params[:ip]
      srv.vm.synced_folder ".", "/vagrant", disabled: true, type: "nfs"
      srv.vm.provider('virtualbox') do |v|
        v.memory = params[:memory] || 1024
        v.cpus = params[:cpus] || 1
      end
    end
  end
end
