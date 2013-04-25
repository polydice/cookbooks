#
# Cookbook Name:: sidekiq
# Recipe:: restart
#

node[:deploy].each do |application, deploy|
  execute "restart-sidekiq" do
    command %Q{
      echo "sleep 20 && monit -g sidekiq_#{application} restart all" | at now
    }
  end

  execute "restart-clockworkd" do
    command %Q{
      echo "sleep 20 && monit restart clockworkd_#{application}" | at now
    }
  end
end
