require "bundler/setup"
require "rspec/core/rake_task"

task :default => [:spec, :foodcritic]

RSpec::Core::RakeTask.new

task :foodcritic do
  sh %{foodcritic . --epic-fail any --include rules}
end
