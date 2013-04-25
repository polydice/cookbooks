#
# Cookbook Name:: sidekiq
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  template "#{node[:monit][:conf_dir]}/sidekiq_#{application}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "monitrc.conf.erb"
    variables({
      :application_name => application,
      :deploy => deploy
    })
  end

  template "#{node[:monit][:conf_dir]}/sidekiq_web_#{application}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "web_monitrc.conf.erb"
    variables({
      :application_name => application,
      :deploy => deploy
    })
  end

  template "#{node[:monit][:conf_dir]}/clockworkd_#{application}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "clockworkd_monitrc.conf.erb"
    variables({
      :application_name => application,
      :deploy => deploy
    })
  end

  execute "ensure-sidekiq-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  execute "restart-sidekiq" do
    command %Q{
      echo "sleep 20 && monit -g #{application}_sidekiq restart all" | at now
    }
  end

  execute "restart-clockworkd" do
    command %Q{
      echo "sleep 20 && monit restart #{application}_clockworkd" | at now
    }
  end
end
