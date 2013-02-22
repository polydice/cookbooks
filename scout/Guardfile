guard "bundler" do
  watch("Gemfile")
end

guard "rspec", :cli => "--color --format nested", :version => 2 do
  watch(%r{^libraries/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/#{m[1]}_recipe_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
end

guard "foodcritic", :cookbook_paths => ".", :cli => "--epic-fail any --include rules" do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
end
