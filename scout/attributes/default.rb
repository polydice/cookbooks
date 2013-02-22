default['scout']['user'] = "scout"
default['scout']['group'] = node['scout']['user']
default['scout']['groups'] = []
default['scout']['home'] = "/home/#{node['scout']['user']}"

default['scout']['gem_packages']
default['scout']['rvm_ruby_string'] = nil
default['scout']['rvm_wrapper_prefix'] = "scout"
default['scout']['version'] = "5.6.0"

default['scout']['key'] = nil
default['scout']['name'] = nil
default['scout']['name_prefix'] = nil
default['scout']['name_suffix'] = nil
default['scout']['options']
default['scout']['log_file'] = nil

default['scout']['config_dir'] = "#{node['scout']['home']}/.scout"
default['scout']['plugin_public_key'] = nil
