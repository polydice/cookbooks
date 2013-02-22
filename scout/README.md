Description
===========

Installs/Configures ScoutApp.com Agent

Supports both standard and RVM installations using [Fletcher Nichol's RVM cookbook](https://github.com/fnichol/chef-rvm).

Attributes
==========

User Attributes
---------------

* `node['scout']['user']` - The user Scout is executed as
* `node['scout']['group']` - The group of the Scout user
* `node['scout']['groups']` - Groups to append the Scout user to, if they exist
* `node['scout']['home']` - The home directory of the Scout user, Scout uses this for storage by default

Environment Attributes
----------------------

* `node['scout']['version']` - The Scout rubygem version
* `node['scout']['rvm_ruby_string']` - The RVM-based Ruby version (and optionally gemset) for Scout
* `node['scout']['rvm_wrapper_prefix']` - The prefix to use for the RVM wrapper script
* `node['scout']['gem_packages']` - List gems (and optionally versions) that your Scout plugins need

The gem_packages attribute is a Hash where the keys are rubygem names
and the values are either the gem version to install or blank.

Agent Attributes
----------------

* `node['scout']['key']` - The server's key provided by Scout
* `node['scout']['log_file']` - Full path used to redirect the output of the cron job
* `node['scout']['name']` - The server name to show in Scout
* `node['scout']['name_prefix']` - A common server name prefix to show in Scout
* `node['scout']['name_suffix']` - A common server name suffix to show in Scout
* `node['scout']['options']` - Additional options to pass as arguments to the Scout executable

If you run Scout in multiple environments, then you can optionally set
the key attribute to a Hash of key value pairs where the key is the
chef environment name and the value is the key for that environment.

If `%{name}` appears in your name attributes, this is will be replaced
with the node's name. If `%{chef_environment}` appears in your name
attributes, then it will be replaced with the node's Chef environment.

The options attribute is a Hash where the keys are the long-form
command line argument name and the value is the argument value.

Plugin Public Key Attributes
----------------------------

* `node['scout']['plugin_public_key']` - Your Plugin Public Key used with private plugins
* `node['scout']['config_dir']` - The config directory for Scout, used to setup the Plugin Public Key

Usage
=====

At minimum, the `node['scout']['key']` attribute must be defined. You
will generally want to use Scout's cloud images feature and configure
a key and name per role.

```ruby
name "web_server"

run_list "recipe[rvm::system]", "recipe[scout]"

default_attributes({
  "scout" => {
    "key" => "YOUR-WEB-SERVER-SCOUT-KEY",
    "name" => "Web Server (%{name})",
    "options" => {
      "level" => "debug",
    },
    "rvm_ruby_string" => "ruby-1.9.3-p125@scout",
    "gem_packages" => {
      "request-log-analyzer" => nil,
    },
  },
})
```
