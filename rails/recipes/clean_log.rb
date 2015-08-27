file "/var/log/nginx/icook.tw.access.log.1" do
  action :delete
  backup false
  only_if { File.exists? "/var/log/nginx/icook.tw.access.log.1" }
end

file "/var/log/td-agent/td-agent.log.1" do
  action :delete
  backup false
  only_if { File.exists? "/var/log/td-agent/td-agent.log.1" }
end

bash "Remove Log Files" do
  user "root"
  %w[ /var/log/td-agent/td-agent.log.*.gz /var/log/nginx/icook.tw.access.log.*.gz ].each do |files|
    code <<-EOH
      rm #{files}
    EOH
    Chef::Log.info("#{files} are eliminated.")
  end
end
