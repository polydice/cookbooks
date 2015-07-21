consul_check_def "hhvm" do
  http "http://localhost:8889/check-health"
  interval "30s"
end

consul_service_def "blog-wordpress" do
  port 80
  tags ["http"]
  check(
    interval: "30s",
    http: "http://localhost/wp-admin/"
  )
  notifies :reload, "service[consul]"
end
