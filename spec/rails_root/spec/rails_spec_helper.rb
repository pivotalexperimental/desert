ENV["RAILS_ENV"] ||= "test"
dir = File.dirname(__FILE__)
$LOAD_PATH << "#{dir}/../../../lib"
require "#{dir}/../config/environment"

require "spec"
require "ruby-debug"
require "rr"
require "rr/adapters/rspec"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
