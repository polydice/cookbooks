include_recipe 'knife::deploy'

node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'knife'
    Chef::Log.debug("Skipping deploy::knife_restart for application #{application} as it is not set as a knife app")
    next
  end

  ruby_block "restart knife application #{application}" do
    block do
      Chef::Log.info("restart knife application #{application} via: #{node[:knife][application][:restart_server_command]}")
      Chef::Log.info(`#{node[:knife][application][:restart_server_command]}`)
      $? == 0
    end
  end
end
