require 'minitest/spec'

describe_recipe 'monit::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'stops monit' do
    service('monit').wont_be_running
  end
end
