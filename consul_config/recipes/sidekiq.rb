remote_file "/usr/local/bin/check_sidekiq" do
  source node[:consul][:config]
  owner "root"
  group "root"
  mode "0755"
  action :create
end

host = node[:deploy][:env][:REDIS_URL].sub(/\w+\:\/\//, "").sub(/\/1/, "")

consul_check_def "sidekiq" do
  script "/usr/local/bin/check_sidekiq -h #{host} -d 1"
  interval "30s"
end
