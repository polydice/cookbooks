#
# Cookbook Name:: icook
# Recipe:: unicorn_redis
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  ruby_block "insert_reconnecting_line" do
    block do
      file = Chef::Util::FileEdit.new("#{deploy[:deploy_to]}/shared/config/unicorn.conf")
      file.insert_line_after_match("# correctly implements pread()/pwrite() system calls)", "$redis.client.reconnect")
      file.write_file
    end
  end
end
