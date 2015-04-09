service "td-agent" do
  action [:enable, :restart]
end

group "www-data" do
  action :modify
  members "td-agent"
  append true
end