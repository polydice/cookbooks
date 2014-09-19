template '/etc/logrotate.d/nginx' do
  path '/etc/logrotate.d/nginx'
  backup false
  source 'logrotate.erb'
  owner 'root'
  group 'root'
  mode 0644
end
