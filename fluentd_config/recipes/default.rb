#
# Cookbook Name:: fluentd_config
# Recipe:: default
#
# Copyright 2015, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

include_recipe "td-agent::default"

if url = node[:fluentd][:config_url]
  service "td-agent" do
    action [ :enable, :start ]
  end

  remote_file "/etc/td-agent/td-agent.conf" do
    source url
    owner "root"
    group "root"
    mode 00644
    notifies :restart, "service[td-agent]"
  end
end

group "www-data" do
  action :modify
  members "td-agent"
  append true
end
