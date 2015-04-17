#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2015, Frozenfung
#
# All rights reserved - Do Not Redistribute
#


include_recipe "apt"
include_recipe "monit"
include_recipe "java"
include_recipe "elasticsearch"
include_recipe "elasticsearch::monit"
include_recipe "elasticsearch::plugins"




