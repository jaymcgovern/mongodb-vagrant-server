require 'yaml'

module VagrantPlugins
	module DbServerConfig
		class Config < Vagrant.plugin( 2, :config )
			attr_accessor :guest_port
			attr_accessor :host_port

			def initialize
				settings = YAML::load_file( "settings.yml" )

				@guest_port = settings["db"]["guest_port"] ? settings["db"]["guest_port"] : 27017
				@host_port = settings["db"]["host_port"] ? settings["db"]["host_port"] : 27017
			end
		end

		class Plugin < Vagrant.plugin( "2" )
			name "database config class"
			config "db" do
				require Vagrant.source_root.join( "lib/vagrant/config" )
				Config
			end
		end
	end
end

Vagrant.configure( "2" ) do |config|
	# Tell Vagrant where the VM is and what it's named
	config.vm.box_url = "https://dl.dropboxusercontent.com/u/14662951/Vagrant/ubuntu-app-server.box"

	# Set up DB server machine
	config.vm.define :database do |database|
		database.vm.box = "ubuntu-db-server"

		# Set up communication with the VM
		database.vm.network :forwarded_port, guest: config.db.guest_port, host: config.db.host_port, auto_correct: true

		# Modify virtualbox VM settings
		database.vm.provider "virtualbox" do |v|
			v.name = "MongoDB Server"
		end

		# Set up provisioning
		database.vm.provision :shell, :path => "provision/shell/setup.sh"

		database.vm.provision "puppet" do |puppet|
			puppet.manifests_path = "provision/puppet/manifests"
			puppet.manifest_file = "init.pp"
		end
	end
end
