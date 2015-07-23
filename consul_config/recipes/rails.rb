consul_service_def node[:consul][:app_name] do
  port 80
  tags ["rails"]
  check(
    http "http://localhost:80/rack_health",
    interval: "30s"
  )
  notifies :reload, "service[consul]"
end
