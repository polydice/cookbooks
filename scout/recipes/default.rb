#
# Cookbook Name:: scout
# Recipe:: default

Chef::Log.info "Loading: #{cookbook_name}::#{recipe_name}"


# create user and group
group node[:scout][:group] do
  action [ :create, :manage ]
end
user node[:scout][:user] do
  comment "Scout Agent"
  gid node[:scout][:group]
  home "/home/#{node[:scout][:user]}"
  supports :manage_home => true
  action [ :create, :manage ]
  only_if do node[:scout][:user] != 'root' end
end

# install scout agent gem
gem_package "scout" do
  version node[:scout][:version]
  action :install
end

if node[:scout][:key]
  # initialize scout gem
  crontab_path = case node.platform
  when 'debian','ubuntu'
    "/var/spool/cron/crontabs/#{node[:scout][:user]}"
  when 'redhat','centos','fedora','scientific','suse','amazon'
    "/var/spool/cron/#{node[:scout][:user]}"
  end

  scout_bin = node[:scout][:bin] ? node[:scout][:bin] : "#{Gem.bindir}/scout"
  name_attr = node[:scout][:name] ? %{ --name "#{node[:scout][:name]}"} : ""
  server_attr = node[:scout][:server] ? %{ --server "#{node[:scout][:server]}"} : ""
  roles_attr = node[:scout][:roles] ? %{ --roles "#{node[:scout][:roles].map(&:to_s).join(',')}"} : ""
  http_proxy_attr = node[:scout][:http_proxy] ? %{ --http-proxy "#{node[:scout][:http_proxy]}"} : ""
  https_proxy_attr = node[:scout][:https_proxy] ? %{ --https-proxy "#{node[:scout][:https_proxy]}"} : ""
  
  code = <<-EOH
  #{scout_bin} #{node[:scout][:key]}#{name_attr}#{server_attr}#{roles_attr}#{http_proxy_attr}#{https_proxy_attr}
  EOH

  # schedule scout agent to run via cron
  cron "scout_run" do
    user node[:scout][:user]
    command code
    only_if do File.exist?(scout_bin) end
  end
else
  Chef::Log.warn "The agent will not report to scoutapp.com as a key wasn't provided. Provide a [:scout][:key] attribute to complete the install."
end

if node[:scout][:public_key]
  home_dir = Dir.respond_to?(:home) ? Dir.home(node[:scout][:user]) : File.expand_path("~#{node[:scout][:user]}")
  template "#{home_dir}/.scout/scout_rsa.pub" do
    source "scout_rsa.pub.erb"
    mode 0440
    owner node[:scout][:user]
    group node[:scout][:group]
    action :create
  end
end

if node[:scout][:delete_on_shutdown]
  gem_package 'scout_api'
  template "/etc/rc0.d/scout_shutdown" do
    source "scout_shutdown.erb"
    owner "root"
    group "root"
    mode 0755
  end
else
  bash "delete_scout_shutdown" do
    user "root"
    code "rm -f /etc/rc0.d/scout_shutdown"
  end
end

(node[:scout][:plugin_gems] || []).each do |gemname|
  gem_package gemname
end
