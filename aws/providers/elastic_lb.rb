include Opscode::Aws::Ec2

action :register do
  target_lb = elb.describe_load_balancers.find {|lb| lb[:load_balancer_name] == new_resource.name }
  unless target_lb[:instances].include?(instance_id)
    Chef::Log.info("Adding node to ELB #{new_resource.name}")
    elb.register_instances_with_load_balancer(new_resource.name, instance_id)
  else
    Chef::Log.debug("Node #{instance_id} is already present in ELB instances, no action required.")
  end

  new_resource.updated_by_last_action(true)
  Chef::Log.info("Added node to ELB #{new_resource.name}")
end

action :deregister do
  target_lb = elb.describe_load_balancers.find {|lb| lb[:load_balancer_name] == new_resource.name }
  if target_lb[:instances].include?(instance_id)
    Chef::Log.info("Removing node from ELB #{new_resource.name}")
    elb.deregister_instances_with_load_balancer(new_resource.name, instance_id)
  else
    Chef::Log.debug("Node #{instance_id} is not present in ELB instances, no action required.")
  end

  new_resource.updated_by_last_action(true)
end

private

def elb
  region = instance_availability_zone
  region = region[0, region.length-1]
  @@elb ||= RightAws::ElbInterface.new(new_resource.aws_access_key, new_resource.aws_secret_access_key, { :logger => Chef::Log, :region => region })

  # TODO: Fix RightAWS bug
  @@elb.params[:server] = "elasticloadbalancing.ap-northeast-1.amazonaws.com"
end

