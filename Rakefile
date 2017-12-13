require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc "Run spec tests"
RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = ['--color']
  t.pattern = 'spec/'
end

RuboCop::RakeTask.new do |t|
  t.options = ['--display-cop-names']
end
