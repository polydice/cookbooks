include_recipe 'apt'
include_recipe 'ecs::setup_ubuntu' if node['platform'] == 'ubuntu'
docker_installation 'default'
include_recipe 'ecs::agent'
include_recipe 'ecs::gc'
