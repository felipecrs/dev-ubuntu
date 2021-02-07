# frozen_string_literal: true

# This Vagrantfile is used to build the box and doesn't come packaged in it.
# The one which comes packaged in the box is the src/Vagrantfile.

Vagrant.configure('2') do |config|
  config.vm.box = 'peru/ubuntu-20.04-desktop-amd64'

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.memory = '8096'
    vb.cpus = '4'
  end

  # Upgrade system and install desktop
  config.vm.provision 'shell',
                      privileged: false,
                      path: 'src/provisioners/upgrade-and-desktop.sh'

  # Upgrade VirtualBox Guest Additions
  config.vm.provision 'shell',
                      privileged: false,
                      path: 'src/provisioners/virtualbox-guest-additions.sh',
                      reboot: true

  # Install additional tools
  config.vm.provision 'shell',
                      privileged: false,
                      path: 'src/provisioners/additional-tools.sh'

  # Set customizations
  config.vm.provision 'shell',
                      privileged: false,
                      path: 'src/provisioners/customizations.sh'

  # Clean
  config.vm.provision 'shell',
                      privileged: false,
                      path: 'src/provisioners/clean.sh'
end
