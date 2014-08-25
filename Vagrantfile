# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
MY_DEV_SUBNET = '192.168.10'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :kochiku do |k|
    k.vm.box = 'centos_65_x64'
    k.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box'
    k.vm.hostname = 'kochiku.vagrant.localdomain'
    k.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', '2048']
    end
    k.vm.network :private_network, ip: "#{MY_DEV_SUBNET}.10"
    k.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
    k.vm.provision :shell, path: './script/vagrant-init.sh'
    k.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = 'puppet/modules'
      puppet.manifest_file = 'site.pp'
      puppet.options = '--verbose --debug --modulepath=/vagrant/puppet/modules'
    end
  end

  config.vm.define :kochiku_worker do |w|
    w.vm.box = 'centos_65_x64'
    w.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box'
    w.vm.hostname = 'kochiku-worker.vagrant.localdomain'
    w.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', '2048']
    end
    w.vm.network :private_network, ip: "#{MY_DEV_SUBNET}.20"
    w.vm.provision :shell, path: './script/vagrant-init.sh'
    w.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = 'puppet/modules'
      puppet.manifest_file = 'site.pp'
      puppet.options = '--verbose --debug --modulepath=/vagrant/puppet/modules'
    end
  end
end
