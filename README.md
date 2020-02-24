# **Ubuntu 18.04 for developers** <!-- omit in toc -->

## A Vagrant box with desktop, tools, and adjustments for developers <!-- omit in toc -->

[![Gitter](https://badges.gitter.im/ubuntu1804-4dev/community.svg)](https://gitter.im/ubuntu1804-4dev/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/felipecassiors/ubuntu1804-4dev)
[![Build Status](https://travis-ci.com/felipecassiors/ubuntu1804-4dev.svg?branch=master)](https://travis-ci.com/felipecassiors/ubuntu1804-4dev)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Vagrant box size](https://img.shields.io/endpoint?url=https://runkit.io/felipecassiors/vagrant-box-size/6.0.0/felipecassiors/ubuntu1804-4dev)](https://app.vagrantup.com/felipecassiors/boxes/ubuntu1804-4dev)

It is based on the [Chef Bento](http://chef.github.io/bento/) [ubuntu-18.04](https://app.vagrantup.com/bento/boxes/ubuntu-18.04), the one behind the  [hashicorp/bionic64](https://app.vagrantup.com/hashicorp/boxes/bionic64) official base box.

- [**Requisites**](#requisites)
- [**Vagrant Cloud**](#vagrant-cloud)
- [**Automated Build**](#automated-build)
- [**Tools**](#tools)
  - [Build it manually](#build-it-manually)
  - [Deploy](#deploy)

## **Requisites**

- VirtualBox ([download here](https://www.virtualbox.org/wiki/Downloads))
- Vagrant ([download here](https://www.vagrantup.com/downloads.html))

## **Vagrant Cloud**

This box is available on [Vagrant Cloud](https://app.vagrantup.com/felipecassiors/boxes/ubuntu1804-4dev). For using it:

1. Create a new folder on your computer, like `C:\my-ubuntu1804-4dev`.
2. Open a new terminal there and run `vagrant init felipecassiors/ubuntu1804-4dev`.
3. Notice that a new file called `Vagrantfile` was created. In this file, you can set your personal options for your VM. For a good example, check [my-ubuntu1804-4dev](https://github.com/felipecassiors/my-ubuntu1804-4dev).
4. Run `vagrant up` and be happy!

## **Automated Build**

This box is automatically built by [Travis](https://travis-ci.com/felipecassiors/ubuntu1804-4dev). Every new commit triggers a new build. We use [`semantic-release`](https://github.com/semantic-release/semantic-release) to determine whether we need to release a new version. The loop also tests the new deployed box before releasing it by running `vagrant up` on that version. If it fails, it doesn't release the version and deletes it. For more details check the [`.travis.yml`](.travis.yml) and also the [`ci/deploy.sh`](ci/deploy.sh).

The whole process is:

1. Check out the repository
2. Install the dependencies (VirtualBox and Vagrant)
3. `vagrant up`
4. `vagrant package`
5. Run `semantic-release` to determine whether the build should be released or not and generate the release notes
6. Create a new version and upload the box to the Vagrant Cloud
7. Try to run a `vagrant up` of the uploaded box
8. If the last step succeeds, release the version on [Vagrant Cloud](https://app.vagrantup.com/felipecassiors/boxes/ubuntu1804-4dev), commit the [CHANGELOG](CHANGELOG.md) and create a [GitHub Release](https://github.com/felipecassiors/ubuntu1804-4dev/releases).

## **Tools**

- Visual Studio Code
- Google Chrome
- Postman
- Git
- Docker
- Docker Compose
- Argbash
- OpenJDK 8
- Python3
- Python2
- Node.js 12
- Ruby
- cURL
- jq
- Latest VirtualBox Guest Additions

### Build it manually

Clone the repository, start a new terminal there, and run:

``` bash
vagrant up
```

After the provision is done, you can turn the VM into a box:

``` bash
vagrant package
```

### Deploy

If you want to deploy it in your Vagrant Cloud, you can use the [`ci/deploy.sh`](scripts/deploy.sh). It needs the `VAGRANT_CLOUD_TOKEN` environment variable to be set before running.

``` bash
ci/deploy.sh
```
