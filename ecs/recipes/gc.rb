docker_image 'jamescookie/docker-gc' do
  tag 'latest'
  action :pull
end

docker_container 'docker-gc' do
  action :run_if_missing
  repo 'jamescookie/docker-gc'
  restart_policy 'always'
  volumes [
    '/var/run/docker.sock:/var/run/docker.sock'
  ]
end
