dir = File.dirname(__FILE__)
require "#{dir}/plugin_templates/action_controller"
if Desert::VersionChecker.rails_version_is_below_rc2?
  require "#{dir}/plugin_templates/1.x/action_mailer"
else
  require "#{dir}/plugin_templates/2.x/action_mailer"
end
require "#{dir}/plugin_templates/action_view"