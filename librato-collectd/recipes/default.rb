packagecloud_repo "librato/librato-collectd" do
  type "deb"
end

ruby_block 'librato-credentials' do
  block do
    f = Chef::Util::FileEdit.new('/opt/collectd/etc/collectd.conf.d/librato.conf')
    f.search_file_replace(%r{User ""},
                          "User \"#{node[:librato][:collectd][:user]}\"")
    f.search_file_replace(%r{Password ""},
                          "Password \"#{node[:librato][:collectd][:password]}\"")
    f.write_file
  end

  notifies :restart, "service[collectd]"
  action :nothing
end

package "collectd" do
  notifies :run, "ruby_block[librato-credentials]"
end

include_recipe 'librato-collectd::_service'
