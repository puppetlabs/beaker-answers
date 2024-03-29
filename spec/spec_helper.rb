require 'simplecov'
SimpleCov.start
SimpleCov.minimum_coverage 90
SimpleCov.minimum_coverage_by_file 80

require 'beaker-answers'
require 'helpers'
require 'shared/context.rb'

require 'rspec/its'

RSpec.configure do |config|
  config.include TestFileHelpers
  config.include HostHelpers

  config.expect_with :rspec do |c|
    c.max_formatted_output_length = nil
  end
end