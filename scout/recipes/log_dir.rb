directory File.dirname(node['scout']['log_file']) do
  owner node['scout']['user']
  group node['scout']['group']
  mode "755"
  recursive true
end
