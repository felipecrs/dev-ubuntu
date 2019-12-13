# ubuntu1804-4dev
An Ubuntu 18.04 64-bit Vagrant box with development applications and desktop enabled. It is based on the official base box [ubuntu/bionic64](https://app.vagrantup.com/ubuntu/boxes/bionic64).

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

### Build

Clone the repository, start a new terminal there, and run:
```sh
vagrant up
```

### Vagrant Cloud

Sometimes I upload this box to Vagrant Cloud to make it easier to run, by just downloading it. If you plan to use this way, I suggest you to look my other repository: felipecassiors/my-ubuntu1804-4dev.
