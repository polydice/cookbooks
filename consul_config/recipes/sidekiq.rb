if url = node[:consul][:sidekiq_script_url]
  remote_file "/usr/local/bin/check_sidekiq" do
    source url
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
end

consul_check_def "sidekiq" do
  script "/usr/local/bin/check_sidekiq"
  interval "30s"
end
