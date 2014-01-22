#
# Cookbook Name:: deploy
# Recipe:: knife
#

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  Chef::Log.debug("#{deploy[:application_type]} | #{application}")

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
end
