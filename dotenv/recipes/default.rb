#
# Cookbook Name:: dotenv
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  if deploy[:env]
    file "/srv/www/#{application}/shared/.env" do
      mode 0644
      owner deploy[:user]
      group deploy[:group]
      action :create
      content Dotenv.walk(deploy[:env]).join("\n")
    end
  end
end
