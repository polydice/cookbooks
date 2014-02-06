include_attribute "knife::configure"

node[:deploy].each do |application, _|
  if node[:deploy][application][:environment] && node[:deploy][application][:environment]["HOME"] && node[:deploy][application][:env]
    default[:knife][application][:env] = {"HOME" => node[:deploy][application][:environment]["HOME"]}.merge(node[:deploy][application][:env])
  elsif node[:deploy][application][:environment] && node[:deploy][application][:environment]["HOME"]
    default[:knife][application][:env] = {"HOME" => node[:deploy][application][:environment]["HOME"]}
  elsif node[:deploy][application][:env]
    default[:knife][application][:env] = node[:deploy][application][:env]
  end

  default[:knife][application][:restart_server_command] = "monit restart knife_#{application}_server"
  default[:knife][application][:stop_server_command] = "monit stop knife_#{application}_server"

  default[:knife][application][:config_file] = "#{node[:deploy][application][:deploy_to]}/shared/config/knife.properties"
  default[:knife][application][:pid_file] = "#{node[:deploy][application][:deploy_to]}/shared/pids/knife.pid"
  default[:knife][application][:output_file] = "#{node[:deploy][application][:deploy_to]}/shared/log/knife.log"

  default[:deploy][application][:symlink_before_migrate] = {
    "config/application.json" => "config/application.json",
    "config/s3.json" => "config/s3.json"
  }
end
