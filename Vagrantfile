# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # https://portal.cloud.hashicorp.com/vagrant/discover?query=bento%2Fubuntu-
  config.vm.box = ENV.fetch("VAGRANT_BOX", "bento/ubuntu-22.04")

  # Forward 3000 from guest to 3000 on host (puma)
  config.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1"
  # Forward 8000 from guest to 8000 on host (nginx)
  config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: "127.0.0.1"

  # Share this folder as /vagrant within the VM
  config.vm.synced_folder ".", "/vagrant"

  # Allow additional time on slower systems
  config.vm.boot_timeout = 10 * 60 # seconds

  # Expand primary disk
  config.vm.disk :disk, size: "50GB", primary: true

  # VirtualBox configuration
  config.vm.provider "virtualbox" do |v|
    # Show GUI by default
    v.gui = (ENV.fetch("VIRTUALBOX_GUI", "true") != "")

    # Customize VM resources
    v.memory = ENV.fetch("VIRTUALBOX_MEMORY", "2048").to_i # MB
    v.cpus = ENV.fetch("VIRTUALBOX_CPUS", "2").to_i
  end

  # Provisioning with Ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "server/playbook.yml"
    ansible.extra_vars = {
      "development_build" => "true",
    }.compact
  end

  # Mounting /vagrant/node_modules
  config.trigger.after [:up, :reload] do |t|
    t.info = "Mounting /vagrant/node_modules"
    t.run_remote = { inline: "sudo mount /vagrant/node_modules" }
  end

  config.ssh.forward_agent = true
end
