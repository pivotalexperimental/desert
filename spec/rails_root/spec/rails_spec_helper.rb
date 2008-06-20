ENV["RAILS_ENV"] ||= "test"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{dir}/../../../lib")
require "#{dir}/../config/environment"

require "action_controller/test_process"
require "spec"
require "ruby-debug"
require "rr"
require "rr/adapters/rspec"

require "#{dir}/spec_helpers/remove_project_constants_helper"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end

Spec::Example::ExampleMethods.module_eval do
  def dependencies
    ActiveSupport.const_defined?(:Dependencies) ? ActiveSupport::Dependencies : Dependencies
  end
end

ActiveRecord::Migrator.migrate(File.expand_path("#{dir}/../db/migrate"))
