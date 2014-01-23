require 'minitest/spec'

describe_recipe 'monit::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should install the service'
  it 'should enable the service'
end
