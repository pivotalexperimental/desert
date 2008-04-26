require "active_support"
require "active_record"
require "action_controller"
require "action_mailer"

module Desert
  SUPPORTED_RAILS_VERSIONS = {
    "1.2.5" => {'version' => '1.2.5', 'git_tag' => 'v1.2.5'},
    "1.99.0" => {'version' => '1.99.0', 'git_tag' => 'v2.0.0_RC1'},
    "2.0.2" => {'version' => '2.0.2', 'git_tag' => 'v2.0.2'},
  }
end

dir = File.dirname(__FILE__)
require "#{dir}/desert/plugin"
require "#{dir}/desert/manager"
require "#{dir}/desert/version_checker"
require "#{dir}/desert/rails"
require "#{dir}/desert/ruby"
require "#{dir}/desert/plugin_migrations"
require "#{dir}/desert/plugin_templates"
