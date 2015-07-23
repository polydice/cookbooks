remote_file "/usr/local/bin/check_sidekiq" do
  source node[:consul][:config]
  owner "root"
  group "root"
  mode "0755"
  action :create
end

consul_check_def "sidekiq" do
  script "/usr/local/bin/check_sidekiq"
  interval "30s"
end
