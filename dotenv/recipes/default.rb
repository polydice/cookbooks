#
# Cookbook Name:: dotenv
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  if deploy[:env]
    file "#{deploy[:deploy_to]}/shared/.env" do
      mode 0644
      owner deploy[:user]
      group deploy[:group]
      action :create
      content Dotenv.walk(deploy[:env]).join("\n")
    end
  end
end
