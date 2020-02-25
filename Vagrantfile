# This Vagrantfile is used to build the box and doesn't come packaged in it.
# The one which comes packaged in the box is the src/Vagrantfile.

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = "2"
  end

  # Upgrade system and install desktop
  config.vm.provision "shell", privileged: false, path: "src/provisioners/upgrade-and-desktop.sh", reboot: true

  # Upgrade VirtualBox Guest Additions
  config.vm.provision "shell", privileged: false, path: "src/provisioners/virtualbox-guest-additions.sh", reboot: true

  # Install the other stuff
  config.vm.provision "shell", privileged: false, path: "src/provisioners/additional-tools.sh"

  # Run customization script
  config.vm.provision "shell", privileged: false, path: "src/provisioners/customization.sh"

  # Clean stuff
  config.vm.provision "shell", privileged: false, path: "src/provisioners/clean.sh"

end
