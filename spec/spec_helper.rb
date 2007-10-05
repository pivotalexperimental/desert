require "rubygems"
require "logger"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{dir}/../lib")
$LOAD_PATH << "#{dir}/external_files"

RAILS_ROOT = "#{dir}/rails_root"
RAILS_DEFAULT_LOGGER = Logger.new(StringIO.new(""))

require "spec"
require "rr"
require "active_support"
require "initializer"
require "action_controller"
require "desert"
require "ruby-debug"
require "spec/spec_helpers/remove_project_constants_helper"
require "spec/spec_helpers/manager_fixture"
require "spec/spec_helpers/mock_connection"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end