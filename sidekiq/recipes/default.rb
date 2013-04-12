#
# Cookbook Name:: sidekiq
# Recipe:: default
#

node[:deploy].each do |applicationlication, deploy|
  template "/etc/monit.d/sidekiq_#{applicationlication}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "monitrc.conf.erb"
    variables({
      :application_name => application,
      :deploy => deploy
    })
  end

  template "/etc/init.d/sidekiq" do
    owner 'root'
    group 'root'
    mode 0755
    source "sidekiq.erb"
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
end
