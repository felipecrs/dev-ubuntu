### [4.0.1](https://github.com/felipecassiors/ubuntu1804-4dev/compare/v4.0.0...v4.0.1) (2020-03-02)


### Bug Fixes

* **desktop:** flat remix theme not being applied ([42272a7](https://github.com/felipecassiors/ubuntu1804-4dev/commit/42272a734f2bf00516611c653d306d58ad5f48fd)), closes [#24](https://github.com/felipecassiors/ubuntu1804-4dev/issues/24)

## [4.0.0](https://github.com/felipecassiors/ubuntu1804-4dev/compare/v3.0.0...v4.0.0) (2020-02-29)


### ⚠ BREAKING CHANGES

* **virtualbox:** The `modifyvm --clipboard-mode` introduced in VirtualBox 6.1 does not work with the
Guest Additions version 6.0 (the currently stable one). However, VirtualBox 6.1.4 restored the
compatibility with the old `--clipboard` option so make sure to update your VirtualBox.

### Bug Fixes

* **desktop:** remove theme override ([fbe44b1](https://github.com/felipecassiors/ubuntu1804-4dev/commit/fbe44b12d92686ead3c9c497196ab57358d3b8eb))
* **virtualbox:** revert guest additions to stable version ([cfa1d3e](https://github.com/felipecassiors/ubuntu1804-4dev/commit/cfa1d3ec60c4823eed1718d3689c88277a3e2ce4)), closes [#22](https://github.com/felipecassiors/ubuntu1804-4dev/issues/22)

## [3.0.0](https://github.com/felipecassiors/ubuntu1804-4dev/compare/v2.0.2...v3.0.0) (2020-02-25)


### ⚠ BREAKING CHANGES

* since now there is a default Vagrantfile package with this box, you don't have to define some options again, such as the `vb.gui = true`
* **desktop:** if you were used to the default look of Ubuntu, this is a major change.

### Features

* add a default Vagrantfile with default options ([0ff2e1d](https://github.com/felipecassiors/ubuntu1804-4dev/commit/0ff2e1dd931332fbfd1ff14a36987ac39f9f5d52)), closes [#13](https://github.com/felipecassiors/ubuntu1804-4dev/issues/13)
* **desktop:** switch to Flat Remix theme ([f09141b](https://github.com/felipecassiors/ubuntu1804-4dev/commit/f09141bfd9e73e4df1337e32518affdc3cc0d65b)), closes [#17](https://github.com/felipecassiors/ubuntu1804-4dev/issues/17)

### [2.0.2](https://github.com/felipecassiors/ubuntu1804-4dev/compare/v2.0.1...v2.0.2) (2020-02-17)


### Bug Fixes

* **release:** maintenance release ([ad35d18](https://github.com/felipecassiors/ubuntu1804-4dev/commit/ad35d18b1d84daec0f1ae344cfd3d3d623cbbb8b))

### [2.0.1](https://github.com/felipecassiors/ubuntu1804-4dev/compare/v2.0.0...v2.0.1) (2020-02-09)


### Bug Fixes

* **provision:** put provision scripts into their own folder ([453cf53](https://github.com/felipecassiors/ubuntu1804-4dev/commit/453cf53fde8bf9a4e25e9419faabf6e0cd737125))

## [2.0.0](https://github.com/felipecassiors/ubuntu1804-4dev/compare/v1.0.13...v2.0.0) (2020-01-31)


### ⚠ BREAKING CHANGES

* **virtualbox:** it is required to upgrade your VirtualBox to 6.1 since
the modifyvm option "clipboard" has changed to "clipboard-mode".

### Features

* **virtualbox:** add support for VirtualBox 6.1 ([3a7507b](https://github.com/felipecassiors/ubuntu1804-4dev/commit/3a7507bca6b8675db090b17e25db12c262147783))
