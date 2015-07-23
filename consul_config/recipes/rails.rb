consul_service_def node[:opsworks][:applications][0][:slug_name] do
  tags ["rails"]
  check(
    http "http://localhost:80/rack_health",
    interval: "30s"
  )
  notifies :reload, "service[consul]"
end
