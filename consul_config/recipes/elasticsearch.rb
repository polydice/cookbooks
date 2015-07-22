remote_file do
  "wget https://raw.githubusercontent.com/orthecreedence/check_elasticsearch/master/check_elasticsearch /usr/local/bin/check_elasticsearch"
end

consul_def_check "elasticsearch" do
  script "/usr/local/bin/check_elasticsearch"
  interval "30s"
end
