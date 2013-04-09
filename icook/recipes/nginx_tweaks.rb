#
# Cookbook Name:: icook
# Recipe:: nginx_tweaks
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx::service"

node[:deploy].each do |application, deploy|
  ruby_block "insert_client_max_body_size_line" do
    block do
      file = Chef::Util::FileEdit.new("#{node[:nginx][:dir]}/sites-available/#{application}")
      file.search_file_delete_line("client_max_body_size")
      file.insert_line_after_match("keepalive_timeout", "  client_max_body_size 32m;")
      file.write_file
    end

    notifies :reload, resources(:service => 'nginx')

    only_if do File.exist?("#{node[:nginx][:dir]}/sites-available/#{application}") end
  end
end
