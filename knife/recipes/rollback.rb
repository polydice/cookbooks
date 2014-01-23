node[:deploy].each do |application, _|
  if node[:deploy][application][:application_type] != 'knife'
    Chef::Log.debug("Skipping knife::rollback for application #{application} as it is not set as a knife app")
    next
  end

  deploy node[:deploy][application][:deploy_to] do
    user node[:deploy][application][:user]
    action 'rollback'
    restart_command "sleep #{node[:deploy][application][:sleep_before_restart]} && #{node[:knife][application][:restart_server_command]}"

    only_if do
      File.exists?(node[:deploy][application][:current_path])
    end
  end

  ruby_block "restart knife application #{application}" do
    block do
      Chef::Log.info("restart knife application via: #{node[:knife][application][:restart_server_command]}")
      Chef::Log.info(`#{node[:knife][application][:restart_server_command]}`)
      $? == 0
    end
  end

end
