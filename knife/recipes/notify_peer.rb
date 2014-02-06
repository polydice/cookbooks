peers = []
node[:opsworks][:layers][:go_app_server][:instances].each do |key, instance|
  peers << "peers=http://#{instance[:private_ip]}:#{node[:application_config][:gc_httppool_port]}"
end

bash "update-gc-peers" do
  code <<-EOH
  curl -X POST -d "#{peers.join("&")}" http://127.0.0.1:#{node[:application_config][:peer_manager_port]}/peers
  cp #{node[:deploy][:knife][:deploy_to]}/shared/config/* #{node[:deploy][:knife][:deploy_to]}/current/config/
  EOH
  action :run
end
