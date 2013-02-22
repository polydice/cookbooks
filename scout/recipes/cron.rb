cron "scout" do
  command ScoutCommand.new(node).to_s
  user node['scout']['user']
end
