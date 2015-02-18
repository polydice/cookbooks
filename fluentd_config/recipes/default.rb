#
# Cookbook Name:: fluentd_config
# Recipe:: default
#
# Copyright 2015, Richard Lee
#
# All rights reserved - Do Not Redistribute
#


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
