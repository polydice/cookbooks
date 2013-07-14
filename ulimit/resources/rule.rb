actions :create, :delete

attribute :type, :kind_of => [Symbol,String], :required => true
attribute :item, :kind_of => [Symbol,String], :required => true
attribute :value, :kind_of => [String,Numeric], :required => true
attribute :domain, :kind_of => [Chef::Resource::UlimitDomain, String], :required => true

def initialize(*args)
  super
  @action = :create
end
