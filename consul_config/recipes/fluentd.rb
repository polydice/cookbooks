consul_check_def "fluentd" do
  http "http://localhost:24220/api/plugins.json"
  interval "30s"
end
