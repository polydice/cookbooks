node[:deploy].each do |application, deploy|
  template "#{deploy[:deploy_to]}/shared/config/shards.yml" do
    source "shards.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database])

    only_if do
      deploy[:database][:slaves].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end
