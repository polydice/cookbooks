# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "./Berksfile"

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "java"
    chef.add_recipe "elasticsearch"
    chef.add_recipe "monit"
    chef.add_recipe "elasticsearch::monit"
    chef.json = {
      elasticsearch: {
        version: "1.4.0"
      },
      java: {
        install_flavor: "oracle",
        jdk_version: "7",
        oracle: {
          accept_oracle_download_terms: true
        }
      }
    }
  end
end
