consul_service_def "fluentd-aggregator" do
  port 24224
  tags ["fluentd"]
  check(
    http: "http://localhost:24220/api/plugins.json",
    interval: "30s"
  )
  notifies :reload, "service[consul]"
end
