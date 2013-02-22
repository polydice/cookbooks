#
# Cookbook Name:: scout
# Recipe:: default
#
# Copyright 2012, Chris Griego
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

install_recipe = node['scout']['rvm_ruby_string'] ? "rvm_install" : "gem_install"

include_recipe "scout::user" unless node['scout']['user'] == "root"
include_recipe "scout::plugin_public_key" if node['scout']['plugin_public_key']
include_recipe "scout::#{install_recipe}"
include_recipe "scout::log_dir" if node['scout']['log_file'] && node['scout']['log_file'] != "/dev/null"
include_recipe "scout::cron"
