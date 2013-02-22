class ScoutCommand
  MissingKeyError = Class.new(ArgumentError)

  attr_reader :node

  def initialize(node)
    @node = node
  end

  def to_s
    [executable, key, arguments, output_redirection].compact.join(" ")
  end

  def executable
    rvm_command = options['rvm_wrapper_prefix'] ? "#{options['rvm_wrapper_prefix']}_scout" : "scout"
    rvm? ? "/usr/local/rvm/bin/#{rvm_command}" : "scout"
  end

  def rvm?
    options['rvm_ruby_string']
  end

  def key
    key_attribute = options['key']
    key_value = key_attribute.respond_to?(:has_key?) ? key_attribute[chef_environment] : key_attribute
    key_value or raise MissingKeyError
  end

  def arguments
    command_options.inject([]) do |array, (option, value)|
      array << %{--#{option} '#{value.gsub("'", "\\\\'")}'}
      array
    end.join(" ") if command_options.any?
  end

  def command_options
    options['options'].to_hash.tap do |command_options|
      command_options.merge!('name' => name) if name
    end
  end

  def name
    if options['name']
      name = [options['name_prefix'], options['name'], options['name_suffix']].
      compact.
      join(" ").
      gsub("%{name}", node.to_hash['name']).
      gsub("%{chef_environment}", chef_environment)
    end
  end

  def output_redirection
    if options['log_file']
      ">> #{options['log_file']} 2>&1"
    end
  end

  private

  def options
    node['scout']
  end

  def chef_environment
    node.to_hash['chef_environment']
  end
end
