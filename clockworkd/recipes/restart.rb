#
# Cookbook Name:: clockworkd
# Recipe:: restart
#

node[:deploy].each do |application, deploy|
  execute "restart-clockworkd" do
    command %Q{
      echo "sleep 20 && monit restart clockworkd_#{application}" | at now
    }
  end
end
