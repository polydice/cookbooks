#
# Cookbook Name:: dotenv
# Recipe:: default
#

module Dotenv
  def self.walk(node, parents = [])
    if node.is_a? Hash
      node.map { |k, v| walk(v, parents + [k]) }.flatten
    else # a Hash
      "export #{(parents).map(&:upcase).join('_')}=#{node}"
    end
  end
end
