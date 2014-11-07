node[:deploy].each do |application, deploy|
  app_root_path = File.join(deploy[:deploy_to], "current")

  if File.exists?("#{app_root_path}/Gemfile")
    Chef::Log.info("Gemfile detected. Running bundle clean.")
    Chef::Log.info("sudo su - #{deploy[:user]} -c 'cd #{app_root_path} && /usr/local/bin/bundle clean'")
    Chef::Log.info(OpsWorks::ShellOut.shellout("sudo su - #{deploy[:user]} -c 'cd #{app_root_path} && /usr/local/bin/bundle clean' 2>&1"))
  end
end
