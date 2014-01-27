peers = []
node[:opsworks][:layers][:go_app_server].each do |_, instance|
  peers << "http://#{instance[:private_ip]}:50000"
end

bash "update-gc-peers" do
  cwd release_path
  code <<-EOH
  echo "updating gc peers"
  curl -X POST -d #{peers.join("&")} http://127.0.0.1:3000/peers
  cp #{node[:deploy][:deploy_to]}/shared/config/* #{node[:deploy][:deploy_to]}/current/config/
  EOH
  action :run
end
