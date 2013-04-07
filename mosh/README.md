Description
===========

This cookbook will install [Mosh](http://mosh.mit.edu).

Requirements
============

## Cookbooks

Strictly speaking no additional cookbooks are *required*, so none are
specific dependencies. However, depending on your platform and package
manager, you may need the following cookbooks:

* [apt](http://community.opscode.com/cookbooks/apt) - for
  apt_repository, used in the "package" recipe for Ubuntu < 12.04 to
  enable backports, where mosh is available.
* [homebrew](http://community.opscode.com/cookbooks/homebrew) - if
  you're installing on Mac OS X and you wish to use homebrew, you'll
  need this cookbook to set brew as the default package manager,
  otherwise the package installation may fail (macports is the default
  provider on Mac OS X.
* [runit](http://community.opscode.com/cookbooks/runit) - can be used
  to set up the mosh server daemon.
* [bluepill](http://community.opscode.com/cookbooks/bluepill) - can be used
  to set up the mosh server daemon.

It is generally assumed that on the appropriate platforms you have
otherwise included these cookbooks' recipes in the node's run list or
in a base role.

## Platforms

This cookbook should work on most platforms where Mosh is available as
a package, and on others where it can be compiled from source.

Attributes
==========

See `attributes/default.rb` for default values.

* `node['mosh']['install_type']` - can be "package" or "source" and
  will determine which recipe is included in the default recipe.
* `node['mosh']['version']` - version of Mosh to install from source
* `node['mosh']['source_url']` - URL to the source tarball
* `node['mosh']['source_checksum']` - SHA256 checksum of the source
  tarball
* `node['mosh']['init_style']` - type of init system to use for
  setting up the mosh daemon(s).  

Recipes
=======

## default

Includes package or source recipe based on the value of the
`node['mosh']['install_type']` attribute.

## package

Installs the mosh package using the package installation instructions
from the [Mosh home page](http://mosh.mit.edu). Should work on the
following platforms:

* Ubuntu
* Debian
* Fedora
* ArchLinux
* Gentoo
* Mac OS X

## source

Installs Mosh from the source tarball per the instructions on the home page.

Usage
=====

Put `recipe[mosh]` in your node's run list and it should install Mosh
for you. If it fails, you may need to adjust the `install_type`
attribute as described above.

License and Author
==================

Author:: Joshua Timberman <opensource@housepub.org>
Copyright:: Copyright (c) 2012, Joshua Timberman
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
