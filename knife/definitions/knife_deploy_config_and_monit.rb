define :knife_deploy_config_and_monit do
  # application_name
  # deploy_to
  # monit_conf_dir
  # group
  # user
  # s3_access_key
  # s3_secret_key
  # private_ip
  # gc_port
  # pm_port
  # web_port
  # knife_application_settings

  service 'monit' do
    action :nothing
  end

  template "#{params[:deploy_to]}/shared/config/s3.json" do
    source  's3.json.erb'
    mode    '0660'
    owner    params[:user]
    group    params[:group]
    variables(
      "access_key" => params[:s3_access_key],
      "secret_key" => params[:s3_secret_key]
    )
  end


  template "#{params[:deploy_to]}/shared/config/application.json" do
    source  'application.json.erb'
    mode    '0660'
    owner    params[:user]
    group    params[:group]
    variables(
      "private_ip" => params[:private_ip],
      "gc_port" => params[:gc_port],
      "pm_port" => params[:pm_port],
      "web_port" => params[:web_port]
    )
  end

  template "#{params[:deploy_to]}/current/knife-#{params[:application_name]}-server-daemon" do
    source   'knife-server-daemon.erb'
    owner    'root'
    group    'root'
    mode     '0751'
    variables(
      :pid_file         => params[:knife_application_settings][:pid_file],
      :release_path     => "#{params[:deploy_to]}/current",
      :application_name => params[:application_name],
      :config_file      => params[:knife_application_settings][:config_file],
      :output_file      => params[:knife_application_settings][:output_file]
    )
  end

  template "#{params[:monit_conf_dir]}/knife_#{params[:application_name]}_server.monitrc" do
    source  'knife_server.monitrc.erb'
    owner   'root'
    group   'root'
    mode    '0644'
    variables(
      :application_name => params[:application_name],
      :deploy_to     => params[:deploy_to],
      :port             => 80
    )
    notifies :restart, resources(:service => 'monit'), :immediately
  end
end
