#
# Cookbook Name:: openswan
# Recipe:: default
#
# Copyright 2013, Wanelo, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ipaddr_extensions'

template "#{node['openswan']['ppp_path']}/chap-secrets" do
  source "chap-secrets.erb"
  variables({
    :users => node['openswan']['users']
  })
notifies :restart, "service[xl2tpd]"
notifies :restart, "service[ipsec]"
end

execute "apt-get update" do
  command "apt-get update && touch /etc/apt/openswan_update_completed"
  not_if "ls /etc/apt/openswan_update_completed"
end

file "/var/log/ppp-ipupdown.log" do
  action :touch
  not_if { File.exists?("/var/log/ppp-ipupdown.log") } # No touching!
end

package "openswan" do
  action :install
end

execute "turn on ipv4 forwarding" do
  command "echo 1 > /proc/sys/net/ipv4/ip_forward"
  not_if "grep 1 /proc/sys/net/ipv4/ip_forward"
end

bash "turn off redirects" do
  code <<-EOH
  for redirect in `ls /proc/sys/net/ipv4/conf/*/send_redirects`
    do echo 0 > $redirect
  done
  EOH
  not_if "grep 0 /proc/sys/net/ipv4/conf/tunl0/send_redirects"
end

["ppp", "xl2tpd"].each do |p|
  package p
end

template "#{node['openswan']['xl2tpd_path']}/xl2tpd.conf" do
  source "xl2tpd.conf.erb"
  notifies :restart, "service[xl2tpd]"
end

template "#{node['openswan']['ppp_path']}/options.xl2tpd" do
  source "options.xl2tpd.erb"
  notifies :restart, "service[xl2tpd]"
end

template "/etc/ipsec.secrets" do
  source "ipsec.secrets.erb"
  notifies :restart, "service[ipsec]"
end

template "/etc/ipsec.conf" do
  source "ipsec.conf.erb"
  notifies :restart, "service[ipsec]"
end

service "xl2tpd" do
  supports :status => true, :restart => true, :start => true, :stop => true
end

service "ipsec" do
  supports :status => true, :restart => true, :start => true, :stop => true
end

remote_file "/var/tmp/linux-image-3.8.4-joyent-ubuntu-12-opt_1.0.0_amd64.deb" do
  source "http://l03.ryan.net/data/linux-image-3.8.4-joyent-ubuntu-12-opt_1.0.0_amd64.deb"
end

remote_file "/var/tmp/linux-headers-3.8.4-joyent-ubuntu-12-opt_1.0.0_amd64.deb" do
  source "http://l03.ryan.net/data/linux-headers-3.8.4-joyent-ubuntu-12-opt_1.0.0_amd64.deb"
end

execute "install custom joyent linux headers" do
  command "dpkg --install --force-confnew /var/tmp/linux-headers-3.8.4-joyent-ubuntu-12-opt_1.0.0_amd64.deb && dpkg --install --force-confnew /var/tmp/linux-image-3.8.4-joyent-ubuntu-12-opt_1.0.0_amd64.deb"
  not_if "ls /lib/modules/3.8.4-joyent-ubuntu-12-opt/kernel"
end

execute "turn on public SNAT" do
  command "iptables -t nat -I POSTROUTING -o eth0 -j SNAT --to #{node['ipaddress']}"
  not_if "iptables -L -t nat | grep #{node['ipaddress']}"
  notifies :restart, "service[xl2tpd]"
  notifies :restart, "service[ipsec]"
end

execute "turn on private SNAT" do
  command "iptables -t nat -I POSTROUTING -o eth1 -j SNAT --to #{node['openswan']['private_ip']}"
  not_if "iptables -L -t nat | grep #{node['openswan']['private_ip']}"
  notifies :restart, "service[xl2tpd]"
  notifies :restart, "service[ipsec]"
end
