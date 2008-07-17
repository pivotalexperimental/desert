dir = File.dirname(__FILE__)
require "#{dir}/plugin_templates/action_controller"
if Desert::VersionChecker.rails_version_is_below_1990?
  require "#{dir}/plugin_templates/1.2.0/action_mailer"
elsif Desert::VersionChecker.rails_version_is_below_rc2?
  require "#{dir}/plugin_templates/1.99.0/action_mailer"
else
  require "#{dir}/plugin_templates/2.0.0/action_mailer"
end
require "#{dir}/plugin_templates/action_view"
require "#{dir}/plugin_templates/view_paths"