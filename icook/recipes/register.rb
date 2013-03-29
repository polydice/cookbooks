#
# Cookbook Name:: icook
# Recipe:: register
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

include_recipe "aws"

aws_elastic_lb "register with elb" do
    aws_access_key node[:aws][:access_key_id]
    aws_secret_access_key node[:aws][:secret_access_key]
    name node[:elb][:name]
    action :register
end
