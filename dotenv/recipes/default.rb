#
# Cookbook Name:: dotenv
# Recipe:: default
#

def walk(node, parents = [])
  if node.is_a? Hash
    node.map { |k, v| walk(v, parents + [k]) }.flatten
  else # a Hash
    "#{(parents).map(&:upcase).join('_')}=#{node}"
  end
end

node[:deploy].each do |application, deploy|
  if deploy[:env]
    file "#{deploy[:deploy_to]}/shared/.env" do
      mode 0644
      owner deploy[:user]
      group deploy[:group]
      action :create
      content walk(deploy[:env]).join("\n")
    end
  end
end
