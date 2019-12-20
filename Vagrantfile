# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true

    vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--vram", "128"]

    vb.customize ["modifyvm", :id, "--audiocontroller", "hda"]

    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]

    vb.memory = "4096"
    vb.cpus = "2"
  end

  # Upgrade system and install desktop
  config.vm.provision "shell", privileged: false, path: "upgrade-and-desktop.sh"

  # Reboot
  config.vm.provision :reload

  # Upgrade VirtualBox Guest Additions
  config.vm.provision "shell", privileged: false, path: "virtualbox-guest-additions.sh"

  # Reboot
  config.vm.provision :reload

  # Install the other stuff
  config.vm.provision "shell", privileged: false, path: "additional-tools.sh"

end
