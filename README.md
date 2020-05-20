# **Dev Ubuntu 20.04** <!-- omit in toc -->

## A Vagrant box with desktop, tools, and adjustments for developers <!-- omit in toc -->

[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/felipecassiors/dev-ubuntu-20.04)
[![Build Status](https://travis-ci.com/felipecassiors/dev-ubuntu-20.04.svg?branch=master)](https://travis-ci.com/felipecassiors/dev-ubuntu-20.04)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Vagrant box size](https://img.shields.io/endpoint?url=https://runkit.io/felipecassiors/vagrant-box-size/6.0.0/felipecassiors/dev-ubuntu-20.04)](https://app.vagrantup.com/felipecassiors/boxes/dev-ubuntu-20.04)

This box is based on [`peru/ubuntu-20.04-desktop-amd64`](https://app.vagrantup.com/peru/boxes/ubuntu-20.04-desktop-amd64), which is a vagrant box for Ubuntu 20.04 Desktop.

- [**Requisites**](#requisites)
- [**Vagrant Cloud**](#vagrant-cloud)
- [**Automated Build**](#automated-build)
- [**Tools**](#tools)
- [Build it manually](#build-it-manually)
- [Deploy](#deploy)

## **Requisites**

- VirtualBox ([download here](https://www.virtualbox.org/wiki/Downloads))
- Vagrant ([download here](https://www.vagrantup.com/downloads.html))
  
> 💡 **Pro tip**
> On Windows, you can install both at once with [Chocolatey](https://chocolatey.org/install) with
>
> ```powershell
> choco install virtualbox vagrant
> ```

## **Vagrant Cloud**

This box is available on [Vagrant Cloud](https://app.vagrantup.com/felipecassiors/boxes/dev-ubuntu-20.04). For using it:

1. Create a new folder on your computer, like `C:\my-dev-ubuntu-20.04`.
2. Open a new terminal there and run `vagrant init felipecassiors/dev-ubuntu-20.04`.
3. Notice that a new file called `Vagrantfile` was created. In this file, you can set your personal options for your VM. For a good example, check [my-dev-ubuntu-20.04](https://github.com/felipecassiors/my-dev-ubuntu-20.04).
4. Run `vagrant up` and be happy!

## **Automated Build**

This box is automatically built by [Travis](https://travis-ci.com/felipecassiors/dev-ubuntu-20.04). Every new commit triggers a new build. We use [`semantic-release`](https://github.com/semantic-release/semantic-release) to determine whether we need to release a new version. The loop also tests the new deployed box before releasing it by running `vagrant up` on that version. If it fails, it doesn't release the version and deletes it. For more details check the [`.travis.yml`](.travis.yml) and also the [`ci/deploy.sh`](ci/deploy.sh).

The whole process is:

1. Check out the repository
2. Install the dependencies (VirtualBox and Vagrant)
3. `vagrant up`
4. `vagrant package`
5. Run `semantic-release` to determine whether the build should be released or not and generate the release notes
6. Create a new version and upload the box to the Vagrant Cloud
7. Try to run a `vagrant up` of the uploaded box
8. If the last step succeeds, release the version on [Vagrant Cloud](https://app.vagrantup.com/felipecassiors/boxes/dev-ubuntu-20.04), commit the [CHANGELOG](CHANGELOG.md) and create a [GitHub Release](https://github.com/felipecassiors/dev-ubuntu-20.04/releases).

## **Tools**

- Visual Studio Code
- Google Chrome
- Postman
- Git
- Docker
- Docker Compose
- Argbash
- OpenJDK 8
- Python 3
- Node.js 12
- Ruby
- cURL
- jq

## Build it manually

Clone the repository, start a new terminal there, and run:

``` bash
vagrant up
```

After the provision is done, you can turn the VM into a box:

``` bash
vagrant package
```

## Deploy

If you want to deploy it in your Vagrant Cloud, you can use the [`ci/deploy.sh`](scripts/deploy.sh). It needs the `VAGRANT_CLOUD_TOKEN` environment variable to be set before running.

``` bash
ci/deploy.sh
```
