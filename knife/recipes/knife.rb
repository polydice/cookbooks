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

  template "#{deploy[:current_path]}/config/application.json" do
    source "application.json.erb"
    mode 0755
    group deploy[:group]
    owner deploy[:user]

    variables(
      "private_ip" => node[:opsworks][:instance][:private_ip],
      "gc_port" => node[:application_config][:gc_httppool_port],
      "pm_port" => node[:application_config][:peer_manager_port],
      "web_port" => node[:application_config][:web_server_port]
    )
  end

  bash "build from the go source of #{application}" do
    code <<-EOH
    export GOPATH=/opt/go
    mkdir -p /opt/go/src/github.com/polydice/knife
    cp -rf #{deploy[:current_path]}/* /opt/go/src/github.com/polydice/knife/
    cd /opt/go/src/github.com/polydice/knife
    /usr/local/go/bin/go get
    EOH

    action :run
  end
end
