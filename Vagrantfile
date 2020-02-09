# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-18.04"

    config.vm.provider "virtualbox" do |vb|
    vb.gui = true

    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--vrde", "off"]

    vb.customize ["modifyvm", :id, "--audiocontroller", "hda"]

    vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]

    vb.memory = "4096"
    vb.cpus = "2"
  end

  # Upgrade system and install desktop
  config.vm.provision "shell", privileged: false, path: "provision/upgrade-and-desktop.sh", reboot: true

  # Upgrade VirtualBox Guest Additions
  config.vm.provision "shell", privileged: false, path: "provision/virtualbox-guest-additions.sh", reboot: true

  # Install the other stuff
  config.vm.provision "shell", privileged: false, path: "provision/additional-tools.sh"

  # Run customization script
  config.vm.provision "shell", privileged: false, path: "provision/customization.sh"

  # Clean stuff
  config.vm.provision "shell", privileged: false, path: "provision/clean.sh"

end
