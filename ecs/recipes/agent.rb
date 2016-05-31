%w(/var/log/ecs /etc/ecs /var/lib/ecs/data).each do |dir|
  directory dir do
    recursive true
  end
end

docker_image 'amazon/amazon-ecs-agent' do
  action :pull_if_missing
end

docker_container 'ecs-agent' do
  action :run_if_missing
  env [
    'ECS_LOGFILE=/log/ecs-agent.log',
    'ECS_DATADIR=/data/',
    'ECS_APPARMOR_CAPABLE=true'
  ].concat(node[:ecs] || [])
  port '127.0.0.1:51678:51678'
  repo 'amazon/amazon-ecs-agent'
  restart_policy 'always'
  volumes [
    '/var/run/docker.sock:/var/run/docker.sock',
    '/var/log/ecs:/log',
    '/var/lib/ecs/data:/data',
    '/var/lib/docker:/var/lib/docker',
    '/sys/fs/cgroup:/sys/fs/cgroup:ro',
    '/var/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro'
   ]
end
