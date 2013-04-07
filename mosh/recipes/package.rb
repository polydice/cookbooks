#
# Author:: Joshua Timberman <opensource@housepub.org>
# Copyright:: Copyright (c) 2012, Joshua Timberman
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when "ubuntu"
  if node['platform_version'].to_f < 12.04

    include_recipe "apt"

    apt_repository "mosh-ppa" do
      uri "http://ppa.launchpad.net/keithw/mosh/ubuntu"
      distribution node['lsb']['codename']
      components ['main']
      keyserver "keyserver.ubuntu.com"
      key "7BF6DFCD"
      action :add
    end

  end

when "redhat", "centos", "scientific", "amazon"
  Chef::Log.warn("mosh is not available in any default repositories on RHEL family systems.")
  Chef::Log.warn("I'll assume you have hosted a package in a repository avaialble to this node and attempt to install anyway.")
  Chef::Log.warn("If you don't have a mosh package, you may try installing from source by setting node['mosh']['install_type'] to \"source\".")
end


package "mosh" do
  package_name case node['platform']
               when "gentoo"
                 "net-misc/mosh"
               when "arch"
                 "mobile-shell-git"
               when "freebsd"
                 "net/mosh"
               when "mac_os_x"
                 use_brew? ? "mobile-shell" : "mosh"
               else
                 "mosh"
               end
  action :install
end
