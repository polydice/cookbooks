#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2015, Frozenfung
#
# All rights reserved - Do Not Redistribute
#

include_recipe "monit"
include_recipe "java"
include_recipe "elasticsearch"
include_recipe "elasticsearch::monit"
include_recipe "elasticsearch::plugins"
include_recipe "elasticsearch::aws"

if url = node[:elasticsearch][:corpus][:ik]
  script "install_ik_data" do
    interpreter "bash"
    user "root"
    cwd node[:elasticsearch][:path]
    code <<-EOH
      wget #{url}
      tar -zxf ik.tar.gz
    EOH
  end
end




