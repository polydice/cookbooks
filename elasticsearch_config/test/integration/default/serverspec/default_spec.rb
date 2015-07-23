require "serverspec"

set :os, :family => "ubuntu"
set :backend, :exec

# Verifying Java is installed in correct version
describe command('java -version') do
  its(:stdout) { should match /java version \"1.8/ }
  its(:exit_status) { should eq 0 }
end

describe service("monit") do
  it { should be_enabled }
  it { should be_running }
end

describe service('elasticsearch') do
  it { should be_enabled }
  it { should be_running }
end

describe service('elasticsearch') do
  it { should be_monitored_by('monit') }
end

# Verifying ES plugins are installed
describe command('plugin -l') do
  its(:stdout) { should match /analysis-ik/ }
  its(:stdout) { should match /cloud-aws/ }
  its(:exit_status) { should eq 0 }
end

# Verifying ik config exists
describe file('/usr/local/etc/elasticsearch/ik.tar.gz') do
  it { should be_file }
end

describe file('/usr/local/etc/elasticsearch/ik') do
  it { should be_directory }
end
