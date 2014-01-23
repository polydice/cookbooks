require 'minitest/spec'

describe_recipe 'monit::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs monit' do
    package('monit').must_be_installed
  end

  it 'creates monit config directory' do
    directory(node[:monit][:conf_dir]).must_exist.with(:group, 'root').and(:owner, 'root')
  end

  it 'creates /etc/default/monit on debian based systems' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    file('/etc/default/monit').must_exist.with(:mode, '644')
  end

  it 'creates main monit conf file' do
    file(node[:monit][:conf]).must_exist.with(:mode, '600')
  end

  it 'ensures main monit conf file has the right config settings' do
    file(node[:monit][:conf]).must_include node[:monit][:conf_dir]
    file(node[:monit][:conf]).must_include 'set logfile syslog'
    file(node[:monit][:conf]).must_include 'set daemon 60'
  end

  it 'ensures logging monitrc file is removed on rhel based systems' do
    file(File.join(node[:monit][:conf_dir], 'logging')).wont_exist
  end

  it 'starts monit' do
    service('monit').must_be_running
  end
end
