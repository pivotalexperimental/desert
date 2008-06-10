require "rubygems"
require "logger"
require "stringio"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{dir}/../")
$LOAD_PATH.unshift("#{dir}/../lib")
$LOAD_PATH << "#{dir}/external_files"

RAILS_ROOT = "#{dir}/rails_root"
RAILS_DEFAULT_LOGGER = Logger.new(StringIO.new(""))

require "#{RAILS_ROOT}/config/boot"

require "active_support"
require "initializer"
require "action_controller"

require "spec"
require "rr"
require "pp"

require "desert"
require "spec/spec_helpers/remove_project_constants_helper"
require "spec/spec_helpers/manager_fixture"
require "spec/spec_helpers/mock_connection"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end

Spec::Example::ExampleMethods.module_eval do
  def dependencies
    ActiveSupport.const_defined?(:Dependencies) ? ActiveSupport::Dependencies : Dependencies
  end
end