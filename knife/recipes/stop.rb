node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'knife'
    Chef::Log.debug("Skipping knife::stop for application #{application} as it is not set as a knife app")
    next
  end

  ruby_block "stop knife application #{application}" do
    block do
      Chef::Log.info("stop knife via: #{node[:knife][application][:stop_server_command]}")
      Chef::Log.info(`#{node[:knife][application][:stop_server_command]}`)
      $? == 0
    end
  end
end
