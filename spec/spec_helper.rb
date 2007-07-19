require "rubygems"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{dir}/../lib")

RAILS_ROOT = "#{dir}/rails_root"

require "spec"
require "rr"
require "rr/adapters/rspec"
require "active_support"
require "initializer"
require "component_fu"

require "spec/spec_helpers/component_manager_fixture"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end