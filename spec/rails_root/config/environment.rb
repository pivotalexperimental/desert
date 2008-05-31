# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present

# Bootstrap the Rails environment, frameworks, and default configuration
dir = File.dirname(__FILE__)
require File.join(dir, 'boot')
$LOAD_PATH.unshift(File.expand_path("#{dir}/../../../lib"))
require "desert"

Rails::Initializer.run do |config|
  unless Desert::VersionChecker.rails_version_is_below_1990?
    config.action_controller.session = { :session_key => "_myapp_session", :secret => 'a'*31 }
  end
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below