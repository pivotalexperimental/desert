ENV["RAILS_ENV"] ||= "test"
dir = File.dirname(__FILE__)
$LOAD_PATH << "#{dir}/../../../lib"
require "#{dir}/../config/environment"

require "spec"

Spec::Runner.configure do |config|
  config.mock_with :rspec
end
