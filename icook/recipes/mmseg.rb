#
# Cookbook Name:: icook
# Recipe:: mmseg
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

src_filepath = "#{Chef::Config['file_cache_path']}/mmseg.tar.gz"
extract_path = "#{node.elasticsearch[:path][:conf]}/mmseg"

remote_file src_filepath do
  source node[:elasticsearch][:mmseg][:url]
  owner node[:elasticsearch][:user]
  group node[:elasticsearch][:user]
  mode 00644
end

bash 'extract_mmseg_dicts' do
  user node[:elasticsearch][:user]
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xzf mmseg.tar.gz -C #{node.elasticsearch[:path][:conf]}
    EOH
  not_if { ::File.exists?(extract_path) }
end
