#
# Cookbook Name:: icook
# Recipe:: redis
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  if node[:redis]
    template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
      source "redis.yml.erb"
      mode 0755
      group deploy[:group]
      owner deploy[:user]
      variables(
        "host" => node[:redis]
      )
    end
  end
end
