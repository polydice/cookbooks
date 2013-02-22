gem_package "scout" do
  version node['scout']['version']
end

node['scout']['gem_packages'].each do |gem_name, gem_version|
  gem_package gem_name do
    version gem_version if gem_version && gem_version.length > 0
  end
end
