include_recipe "monit::service"

service "monit" do
  action :stop
end
