rvm_environment node['scout']['rvm_ruby_string']

rvm_gem "scout" do
  ruby_string node['scout']['rvm_ruby_string']
  version node['scout']['version']
end

node['scout']['gem_packages'].each do |gem_name, gem_version|
  rvm_gem gem_name do
    ruby_string node['scout']['rvm_ruby_string']
    version gem_version if gem_version && gem_version.length > 0
  end
end

rvm_wrapper "scout" do
  binary "scout"
  prefix node['scout']['rvm_wrapper_prefix']
  ruby_string node['scout']['rvm_ruby_string']
end
