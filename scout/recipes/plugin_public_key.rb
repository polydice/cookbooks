directory node['scout']['config_dir'] do
  mode "0750"
  owner node['scout']['user']
  group node['scout']['group']
end

file "#{node['scout']['config_dir']}/scout_rsa.pub" do
  owner node['scout']['user']
  group node['scout']['group']
  mode "0640"
  content node['scout']['plugin_public_key']
end
