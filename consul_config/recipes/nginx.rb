consul_check_def "nginx" do
  http "http://localhost/nginx_status"
  interval "30s"

  notifies :reload, "service[consul]"
end
