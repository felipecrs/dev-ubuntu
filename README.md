# **Dev Ubuntu 20.04** <!-- omit in toc -->

## A Vagrant box with desktop, tools, and adjustments for developers <!-- omit in toc -->

[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/felipecrs/dev-ubuntu-20.04)
[![Build Status](https://travis-ci.com/felipecrs/dev-ubuntu-20.04.svg?branch=master)](https://travis-ci.com/felipecrs/dev-ubuntu-20.04)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Vagrant box size](https://img.shields.io/endpoint?url=https://runkit.io/felipecrs/vagrant-box-size/6.0.0/felipecrs/dev-ubuntu-20.04)](https://app.vagrantup.com/felipecrs/boxes/dev-ubuntu-20.04)

This box is based on [`peru/ubuntu-20.04-desktop-amd64`](https://app.vagrantup.com/peru/boxes/ubuntu-20.04-desktop-amd64), which is a vagrant box for Ubuntu 20.04 Desktop.

- [**What this box have**](#what-this-box-have)
- [**Get started**](#get-started)
  - [**Requisites**](#requisites)
  - [**Creating a VM from this box**](#creating-a-vm-from-this-box)
  - [**Updating to a newer version**](#updating-to-a-newer-version)
- [**Technical details**](#technical-details)
  - [**Automated Build**](#automated-build)
  - [**Build from source**](#build-from-source)

## **What this box have**

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
And probably more

## **Get started**

### **Requisites**

For running this box, you need to have the following tools:

- VirtualBox ([download here](https://www.virtualbox.org/wiki/Downloads))
- Vagrant ([download here](https://www.vagrantup.com/downloads.html))

> 💡 **Pro tip**
>
> On Windows, you can install both at once with [Chocolatey](https://chocolatey.org/install) with
>
> ```powershell
> choco install virtualbox vagrant
> ```

### **Creating a VM from this box**

This box is available on [Vagrant Cloud](https://app.vagrantup.com/felipecrs/boxes/dev-ubuntu-20.04). For using it:

1. Create a new folder on your computer, like:

   ```bash
   mkdir ~/my-dev-ubuntu-20.04
   ```

2. Open a new terminal there and run:

    ```bash
    vagrant init felipecrs/dev-ubuntu-20.04
    ```

3. Notice that a new file called `Vagrantfile` was created. In this file, you can set your personal options for your VM. For a good example, check my own `Vagrantfile` at [my-dev-ubuntu-20.04](https://github.com/felipecrs/my-dev-ubuntu-20.04). There you can find snippets for changing the **keyboard layout**, **timezone** and more.

4. Run the VM and be happy!

   ```bash
   vagrant up
   ```

### **Updating to a newer version**

This box is often updated. If you already a VM created from an older version, to update it you have to perform the following steps:

1. Delete the VM, and this will wipe its data, so be sure you didn't left anything important there.

    ```bash
    vagrant destroy
    ```

2. Download the new box with:

    ```bash
    vagrant box update
    ```

## **Technical details**

The rest of this documentation covers technical details about how this project works.

### **Automated Build**

This box is automatically built by [Travis](https://travis-ci.com/felipecrs/dev-ubuntu-20.04). Every new commit triggers a new build. We use [`semantic-release`](https://github.com/semantic-release/semantic-release) to determine whether we need to release a new version or not. The loop also tests the new deployed box before releasing it by running `vagrant up` on that version. If it fails, it doesn't release the version and deletes it. For more details check the [`.travis.yml`](.travis.yml) and also the [`ci/deploy.sh`](ci/deploy.sh).

The whole process is:

1. Checkout the repository
2. Install the dependencies (VirtualBox and Vagrant)
3. `vagrant up`
4. `vagrant package`
5. Run `semantic-release` to determine whether the build should be released or not and generate the release notes
6. Create a new version and upload the box to the Vagrant Cloud
7. Test the deployed box by trying to run a `vagrant up` of it
8. If the last step succeeds, release the version on [Vagrant Cloud](https://app.vagrantup.com/felipecrs/boxes/dev-ubuntu-20.04), commit the [CHANGELOG](CHANGELOG.md) and create a [GitHub Release](https://github.com/felipecrs/dev-ubuntu-20.04/releases).

### **Build from source**

You can also build the box from source with the following steps:

1. Clone the repository, start a new terminal there, and run:

    ```bash
    vagrant up
    ```

2. After the provision is done, you can turn the VM into a box with:

    ```bash
    vagrant package --vagrantfile src/Vagrantfile
    ```

3. Then, you can add this generated box to your local boxes catalog with:

   ```bash
   vagrant box add package.box dev-ubuntu-20.04
   ```

4. And then you can perform the steps from [**Creating a VM from this box**](#creating-a-vm-from-this-box) as usual, such as:

   ```bash
   mkdir ~/my-dev-ubuntu-20.04
   cd ~/my-dev-ubuntu-20.04
   vagrant init dev-ubuntu-20.04
   vagrant up
   ```

> 💡 **Pro tip**
>
> You can also use the [`test_local.sh`](test_local.sh) script which performs all these previous steps automatically.
