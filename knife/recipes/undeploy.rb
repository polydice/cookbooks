include_recipe 'knife::deploy'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'knife'
    Chef::Log.debug("Skipping knife::undeploy for application #{application} as it is not set as a knife app")
    next
  end

  ruby_block "stop knife application #{application}" do
    block do
      Chef::Log.info("stop knife application via: #{node[:knife][application][:stop_server_command]}")
      Chef::Log.info(`#{node[:knife][application][:stop_server_command]}`)
      $? == 0
    end
  end

  file "#{node[:monit][:conf_dir]}/knife_#{application}_server.monitrc" do
    action :delete
    only_if do
      ::File.exists?("#{node[:monit][:conf_dir]}/knife_#{application}_server.monitrc")
    end
  end

  directory "#{node[:deploy][application][:deploy_to]}" do
    recursive true
    action :delete

    only_if do
      ::File.exists?("#{node[:deploy][application][:deploy_to]}")
    end
  end
end
