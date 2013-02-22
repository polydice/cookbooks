group node['scout']['group']

user node['scout']['user'] do
  comment "ScoutApp.com Agent"
  group node['scout']['group']
  home node['scout']['home']
  supports :manage_home => true
end

node['scout']['groups'].each do |scout_group|
  group scout_group do
    append true
    members node['scout']['user']
    action :manage
  end
end
