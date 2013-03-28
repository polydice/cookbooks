#
# Cookbook Name:: icook
# Recipe:: capistrano
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  %w{ assets bundle public tmp }.each do |dir|
    directory "#{deploy[:deploy_to]}/shared/#{dir}" do
      owner deploy[:user]
      group deploy[:group]
      mode 0770
      action :create
      recursive true
    end
  end
end
