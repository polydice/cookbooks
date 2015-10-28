#
# Cookbook Name:: librato-collectd
# Recipe:: default
#
# Copyright 2015, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

packagecloud_repo "librato/librato-collectd" do
  type "deb"
end

package "collectd"

file '/opt/collectd/etc/collectd.conf.d/librato.conf' do
  f = Chef::Util::FileEdit.new(path)
  f.search_file_replace(%r{User ""},
                        "User \"#{node[:librato][:collectd][:user]}\"")
  f.search_file_replace(%r{Password ""},
                        "Password \"#{node[:librato][:collectd][:password]}\"")
  f.write_file
  notifies :restart, "service[collectd]"
end

include_recipe 'librato-collectd::_service'
