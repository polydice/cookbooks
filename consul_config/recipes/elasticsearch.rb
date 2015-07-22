remote_file "/usr/local/bin/check_elasticsearch" do
  source "https://raw.githubusercontent.com/orthecreedence/check_elasticsearch/master/check_elasticsearch"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

consul_check_def "elasticsearch" do
  script "/usr/local/bin/check_elasticsearch"
  interval "30s"
end
