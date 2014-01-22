#
# Cookbook Name:: deploy
# Recipe:: knife
#

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  if node[:s3_config]
    template "#{deploy[:current_path]}/config/s3.json" do
      source "s3.json.erb"
      mode 0755
      group deploy[:group]
      owner deploy[:user]

      variables(
        "access_key" => node[:s3_config][:access_key],
        "secret_key" => node[:s3_config][:secret_key]
      )
    end
  end

  execute "build from the go source of #{application}" do
    command "export GOPATH=/home/deploy/source"
    cwd deploy[:current_path]
    # The installation of go should be global.
    command "/usr/local/go/bin/go get"
    action :run
  end
end
