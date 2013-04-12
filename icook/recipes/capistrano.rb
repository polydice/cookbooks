#
# Cookbook Name:: icook
# Recipe:: capistrano
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

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
