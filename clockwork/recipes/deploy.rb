#
# Cookbook Name:: clockwork
# Recipe:: deploy
#

node[:deploy].each do |application, deploy|
  release_path = ::File.join(deploy[:deploy_to], 'current')
  env = { "HOME" => "/home/#{deploy[:user]}", "RAILS_ENV" => "production" }.merge(deploy['environment_variables'] || {})
  template "setup clockwork.conf" do
    path "/etc/init/clockwork-#{application}.conf"
    source "clockwork.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      user: deploy[:user],
      group: deploy[:group],
      release_path: release_path,
      env: env,
    })
  end

  service "clockwork-#{application}" do
    provider Chef::Provider::Service::Upstart
    supports stop: true, start: true, restart: true
  end

    # always restart clockwork on deploy since we assume the code must need to be reloaded
    bash 'restart_clockwork' do
      code "echo noop"
      notifies :restart, "service[clockwork-#{application}]"
    end
end
