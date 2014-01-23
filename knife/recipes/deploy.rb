node[:deploy].each do |application, deploy|
  if node[:deploy][application][:application_type] != 'knife'
    Chef::Log.debug("Skipping knife::deploy for application #{application} as it is not set as a knife app")
    next
  end

  knife_deploy_dir do
    user    deploy[:user]
    group   deploy[:group]
    path    deploy[:deploy_to]
  end

  knife_scm do
    deploy_data   node[:deploy][application]
    app           application
  end

  knife_deploy_config_and_monit do
    application_name            application
    hostname                    node[:hostname]
    basicauth_users             node[:knife][application][:basicauth_users]
    knife_application_settings  node[:knife][application]
    deploy_to                   deploy[:deploy_to]
    env_vars                    node[:knife][application][:env]
    monit_conf_dir              node[:monit][:conf_dir]
    group                       deploy[:group]
    user                        deploy[:user]
    service_realm               node[:knife][application][:service_realm]
    s3_access_key               node[:s3_config][:access_key]
    s3_secret_key               node[:s3_config][:secret_key]
  end

  ruby_block "restart knife application #{application}" do
    block do
      Chef::Log.info("restart knife app server via: #{node[:knife][application][:restart_server_command]}")
      Chef::Log.info(`#{node[:knife][application][:restart_server_command]}`)
      $? == 0
    end
  end
end
