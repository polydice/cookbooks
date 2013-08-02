#
# Cookbook Name:: clockworkd
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  template "#{node[:monit][:conf_dir]}/clockworkd_#{application}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "clockworkd_monitrc.conf.erb"
    variables({
      :app_name => application,
      :deploy => deploy
    })
  end

  execute "ensure-clockworkd-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  execute "restart-clockworkd" do
    command %Q{
      echo "sleep 20 && monit restart clockworkd_#{application}" | at now
    }
  end
end
