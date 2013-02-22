require "spec_helper"
require "scout_command"

describe ScoutCommand do
  subject { instance }
  let(:instance) { described_class.new(node) }

  let(:key) { "key" }
  let(:name) { nil }
  let(:name_prefix) { nil }
  let(:name_suffix) { nil }
  let(:options) { {} }
  let(:node_name) { "i-12345678" }
  let(:node_environment) { "_default" }
  let(:rvm_ruby_string) { nil }
  let(:log_file) { nil }
  let(:rvm_wrapper_prefix) { "scout" }

  let :node do
    {
      "chef_environment" => node_environment,
      "name" => node_name,
      "scout" => {
        "key" => key,
        "name" => name,
        "name_prefix" => name_prefix,
        "name_suffix" => name_suffix,
        "options" => options,
        "rvm_ruby_string" => rvm_ruby_string,
        "rvm_wrapper_prefix" => rvm_wrapper_prefix,
        "log_file" => log_file,
      },
    }
  end

  shared_examples_for "raises when no key is given" do
    context "when no key is given" do
      let(:key) { nil }
      it { expect { subject }.to raise_error described_class::MissingKeyError }
    end
  end

  describe "#to_s" do
    subject { instance.to_s }
    include_examples "raises when no key is given"

    context "no special options" do
      it "executes scout and gives it the key" do
        should == "scout #{key}"
      end
    end

    context "with a name" do
      let(:name) { %{My 'Killer' Server} }

      it "uses the escape name arguments" do
        should == %{scout #{key} --name 'My \\'Killer\\' Server'}
      end
    end

    context "with a name with a replaced value" do
      let(:name) { "Role Based Name (%{name})" }

      it "interpolates the embedded name" do
        should == %{scout #{key} --name 'Role Based Name (#{node_name})'}
      end
    end

    context "with rvm_ruby_string set" do
      let(:rvm_ruby_string) { "ruby-1.9.2-p318@scout" }

      it "uses the rvm wrapper" do
        should == %{/usr/local/rvm/bin/scout_scout #{key}}
      end
    end

    context "with output redirection" do
      let(:log_file) { "/path/to/anywhere/scout.out" }

      it "redirects the output" do
        should == %{scout #{key} >> /path/to/anywhere/scout.out 2>&1}
      end
    end
  end

  describe "#rvm?" do
    subject { instance.rvm? }

    context "rvm_ruby_string not set" do
      it { should be_false }
    end

    context "rvm_ruby_string is set" do
      let(:rvm_ruby_string) { "ruby-1.9.2-p318@scout" }
      it { should be_true }
    end
  end

  describe "#executable" do
    subject { instance.executable }

    context "rvm_ruby_string not set" do
      it { should == "scout" }
    end

    context "rvm_ruby_string is set" do
      let(:rvm_ruby_string) { "ruby-1.9.2-p318@scout" }
      it { should == "/usr/local/rvm/bin/scout_scout" }

      context "rvm_wrapper_prefix is set to 'run'" do
        let(:rvm_wrapper_prefix) { "run" }
        it { should == "/usr/local/rvm/bin/run_scout" }
      end

      context "rvm_wrapper_prefix is set to false" do
        let(:rvm_wrapper_prefix) { false }
        it { should == "/usr/local/rvm/bin/scout" }
      end
    end
  end

  describe "#key" do
    subject { instance.key }
    include_examples "raises when no key is given"

    it "uses the key in the node attributes" do
      should == key
    end

    context "environment-specific keys" do
      before { node['scout'].merge!("key" => { node_environment => key }) }
      include_examples "raises when no key is given"

      it "looks up the key by environment" do
        should == key
      end
    end
  end

  describe "#arguments" do
    subject { instance.arguments }

    context "when there are no extra options" do
      it { should be_nil }
    end

    context "when options are provided" do
      let :options do
        {
          "server" => "http://scout.example.com/",
          "level" => "debug",
          "http-proxy" => "http://proxy.example.com/",
        }
      end

      it "serializes the provided options" do
        should == %{--server 'http://scout.example.com/' --level 'debug' --http-proxy 'http://proxy.example.com/'}
      end
    end

    context "when a name is provided" do
      let(:name) { "My Server" }

      it "includes the name" do
        should == %{--name 'My Server'}
      end
    end

    context "when the name has a single quore in it" do
      let(:name) { %{My 'Killer' Server} }

      it "escapes the single quotes" do
        should == %{--name 'My \\'Killer\\' Server'}
      end
    end

    context "when both options and a name are provided" do
      let(:name) { "My Server" }

      let :options do
        {
          "server" => "http://scout.example.com/",
          "level" => "debug",
          "http-proxy" => "http://proxy.example.com/",
        }
      end

      it "includes the name" do
        should include %{--name 'My Server'}
      end

      it "includes the options" do
        should include %{--server 'http://scout.example.com/' --level 'debug' --http-proxy 'http://proxy.example.com/'}
      end
    end
  end

  describe "#command_options" do
    subject { instance.command_options }

    context "when there are no extra options" do
      it { should == {} }
    end

    context "when options are provided" do
      let :options do
        {
          "server" => "http://scout.example.com/",
          "level" => "debug",
          "http-proxy" => "http://proxy.example.com/",
        }
      end

      it "returns the provided options" do
        should == options
      end
    end

    context "when a name is provided" do
      let(:name) { "My Server" }

      it "includes the name" do
        should == { "name" => name }
      end
    end

    context "when both options and a name are provided" do
      let(:name) { "My Server" }

      let :options do
        {
          "server" => "http://scout.example.com/",
          "level" => "debug",
          "http-proxy" => "http://proxy.example.com/",
        }
      end

      it "includes the name" do
        should include("name" => "My Server")
      end

      it "includes the options" do
        should include(options)
      end
    end
  end

  describe "#name" do
    subject { instance.name }

    context "no name" do
      it { should be_nil }
    end

    context %{My 'Killer' Server} do
      let(:name) { %{My 'Killer' Server} }
      it { should == name }
    end

    context "%{name}" do
      let(:name) { "%{name}" }

      it "uses the node name" do
        should == node_name
      end
    end

    context "embeds %{name}" do
      let(:name) { "Role Based Name (%{name})" }

      it "interpolates the embedded name" do
        should == "Role Based Name (#{node_name})"
      end
    end

    context "%{chef_environment}" do
      let(:name) { "%{chef_environment}" }

      it "uses the node environment" do
        should == node_environment
      end
    end

    context "a name and a name prefix" do
      let(:name) { "Name" }
      let(:name_prefix) { "Prefixed" }

      it "prefixes the name" do
        should == "Prefixed Name"
      end

      context "prefix contains %{name}" do
        let(:name_prefix) { "%{name}" }

        it "interpolates the node name in the prefix" do
          should == "#{node_name} #{name}"
        end
      end
    end

    context "a name and a name suffix" do
      let(:name) { "Name" }
      let(:name_suffix) { "Suffixed" }

      it "suffixes the name" do
        should == "Name Suffixed"
      end

      context "suffix contains %{name}" do
        let(:name_suffix) { "%{name}" }

        it "interpolates the node name in the suffix" do
          should == "#{name} #{node_name}"
        end
      end
    end

    context "a name, name prefix, and a name suffix" do
      let(:name) { "Name" }
      let(:name_prefix) { "Prefixed" }
      let(:name_suffix) { "Suffixed" }

      it "prefixes and suffixes the name" do
        should == "Prefixed Name Suffixed"
      end

      context "prefix contains %{chef_environment} and the suffix contains %{name}" do
        let(:name_prefix) { "%{chef_environment}" }
        let(:name_suffix) { "(%{name})" }

        it "interpolates the node name and chef environment" do
          should == "#{node_environment} #{name} (#{node_name})"
        end
      end
    end
  end

  describe "#output_redirection" do
    subject { instance.output_redirection }

    context "output redirection is not set" do
      it { should be_nil }
    end

    context "output redirection is set to /dev/null" do
      let(:log_file) { "/dev/null" }

      it { should == ">> /dev/null 2>&1" }
    end
  end
end

describe ScoutCommand::MissingKeyError do
  it { should be_a_kind_of ArgumentError }
end
