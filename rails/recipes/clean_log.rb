file "/var/log/td-agent/td-agent.log.1" do
  action :delete
  backup false
  only_if { File.exists? "/var/log/td-agent.log.1" }
end

file "/var/log/nginx/icook.tw.access.log.1" do
  action :delete
  backup false
  only_if { File.exists? "/var/log/nginx/icook.tw.access.log.1" }
end

%w[ /var/log/td-agent/td-agent.log.*.gz /var/log/nginx/icook.tw.access.log.*.gz ].each do |path|
  file path do
    action :delete
    backup false
  end
end
