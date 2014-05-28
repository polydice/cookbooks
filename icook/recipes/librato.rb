#
# Cookbook Name:: icook
# Recipe:: librato
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  if node[:librato]
    template "#{deploy[:deploy_to]}/shared/config/librato.yml" do
      source "librato.yml.erb"
      mode 0755
      group deploy[:group]
      owner deploy[:user]
      variables(
        "librato" => node[:librato]
      )
    end
  end
end
