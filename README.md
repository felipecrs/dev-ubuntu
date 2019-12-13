# bionic-4dev
An Ubuntu 18.04 Bionic Vagrant box with development applications and desktop enabled. It is based on [ubuntu/bionic64](https://app.vagrantup.com/ubuntu/boxes/bionic64).

## Requisites

- VirtualBox ([download](https://www.virtualbox.org/wiki/Downloads))
- Vagrant ([download](https://www.vagrantup.com/downloads.html))

## Features

- Visual Studio Code
- Google Chrome
- Postman
- Git (real latest version)
- Docker
- Argbash
- OpenJDK 8
- Python3
- Python2
- Node.js 12
- Ruby
- cURL
- jq
- Latest VirtualBox Guest Additions

## Usage

### Build

Clone the repository, start a new terminal there, and run:
```sh
vagrant up
```

### Download from Vagrant Cloud (may be outdated)

Create a new folder (`bionic-4dev`), start a new terminal there, and run:
```sh
vagrant init felipecassiors/bionic-4dev
```
Edit the `Vagrantfile` and uncomment the `config.vm.provider "virtualbox" do |vb|` block, to make sure the `vb.gui = true` is uncommented. If you want, also customize the `vb.memory = "1024"`. After that, run:
```sh
vagrant up
```

### Configuration

Change the `Vagrantfile` for setting up your VM.
