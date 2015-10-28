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
