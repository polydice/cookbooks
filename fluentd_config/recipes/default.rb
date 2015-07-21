#
# Cookbook Name:: fluentd_config
# Recipe:: default
#
# Copyright 2015, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

include_recipe "td-agent::default"

url = if node[:fluentd][:config_url].is_a?(String)
        node[:fluentd][:config_url]
      else
        node[:fluentd][:config_url][node[:opsworks][:instance][:layers][0]]
      end

if url
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
