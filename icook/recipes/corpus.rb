#
# Cookbook Name:: icook
# Recipe:: corpus
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#


node[:elasticsearch][:corpus].each do |type, url|
  src_filepath = "/tmp/#{type}.tar.gz"
  extract_path = "#{node.elasticsearch[:path][:conf]}/#{type}"

  remote_file src_filepath do
    source url
    owner node[:elasticsearch][:user]
    group node[:elasticsearch][:user]
    mode 00644
  end

  bash 'extract_mmseg_dicts' do
    user node[:elasticsearch][:user]
    cwd ::File.dirname(src_filepath)
    code <<-EOH
    tar xzf #{type}.tar.gz -C #{node.elasticsearch[:path][:conf]}
    EOH
    not_if { ::File.exists?(extract_path) }
  end
end

