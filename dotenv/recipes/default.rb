#
# Cookbook Name:: dotenv
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  if deploy[:env]
    file "/etc/profile.d/#{application}.sh" do
      mode 0755
      owner "root"
      group "root"
      action :create
      content Dotenv.walk(deploy[:env]).join("\n")
    end
  end
end
