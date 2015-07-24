consul_service_def node[:opsworks][:applications][0][:slug_name] do
  tags ["rails"]
  check(
    http: "http://127.0.0.1/rack_health",
    interval: "30s"
  )
  notifies :reload, "service[consul]"
end
