remote_file "/usr/local/bin/check_elasticsearch" do
  source "https://raw.githubusercontent.com/orthecreedence/check_elasticsearch/master/check_elasticsearch"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

consul_service_def "elasticsearch" do
  port 9200
  tags ["elasticsearch"]
  check(
    script: "/usr/local/bin/check_elasticsearch",
    interval: "30s"
  )
  notifies :reload, "service[consul]"
end
