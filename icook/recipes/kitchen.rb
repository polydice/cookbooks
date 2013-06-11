node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/legacy_database.yml" do
      source "legacy_database.yml.erb"
      mode 0660
      group deploy[:group]
      owner deploy[:user]
      variables(
        "legacy_database" => deploy[:legacy_database]
      )
  end
end
