#
# Cookbook Name:: sidekiq
# Recipe:: restart
#

node[:deploy].each do |application, deploy|
  execute "restart-sidekiq" do
    command %Q{
      monit -g sidekiq_#{application} restart all
    }
  end
end
