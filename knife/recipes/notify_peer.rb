peers = []
node[:opsworks][:layers][:go_app_server][:instances].each do |key, instance|
  peers << "http://#{instance[:private_ip]}:50000"
end

bash "update-gc-peers" do
  code <<-EOH
  curl -X POST -d "#{peers.join("&")}" http://127.0.0.1:3000/peers
  cp #{node[:deploy][:deploy_to]}/shared/config/s3.json #{node[:deploy][:deploy_to]}/current/config/s3.json
  EOH
  action :run
end
