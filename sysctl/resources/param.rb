actions :apply, :remove

attribute :key, :kind_of => String
attribute :value, :required => true

def initialize(*args)
  super
  @action = :apply
end
