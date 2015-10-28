#
# Cookbook Name:: librato-collectd
# Recipe:: docker
#
# Copyright 2015, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

group "docker" do
  action :modify
  members "nobody"
  append true
end

service "collectd" do
  supports :status => true, :restart => true, :reload => true
  action [:restart]
end

include_recipe 'librato-collectd::_service'
