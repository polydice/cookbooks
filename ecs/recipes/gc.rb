docker_image 'jamescookie/docker-gc' do
  tag 'latest'
  action :pull
end

docker_container 'docker-gc' do
  repo 'jamescookie/docker-gc'
  volumes [
    '/var/run/docker.sock:/var/run/docker.sock'
  ]
end
