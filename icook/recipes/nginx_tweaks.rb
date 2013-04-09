#
# Cookbook Name:: icook
# Recipe:: nginx_tweaks
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  template "#{node[:nginx][:dir]}/sites-available/#{application}" do
    ruby_block "insert_client_max_body_size_line" do
    block do
      file = Chef::Util::FileEdit.new("#{deploy[:deploy_to]}/shared/config/unicorn.conf")
      file.search_file_delete_line("client_max_body_size")
      file.insert_line_after_match("keepalive_timeout", "  client_max_body_size 32m;")
      file.write_file
    end
  end
end

include_recipe "nginx::service"
notifies :reload, resources(:service => 'nginx')
