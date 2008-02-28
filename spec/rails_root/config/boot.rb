# Don't change this file. Configuration is done in config/environment.rb and config/environments/*.rb

unless defined?(RAILS_ROOT)
  root_path = File.join(File.dirname(__FILE__), '..')

  unless RUBY_PLATFORM =~ /(:?mswin|mingw)/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

unless defined?(Rails::Initializer)
  if ENV['RAILS_VERSION'] == 'EDGE'
    Dir["#{RAILS_ROOT}/vendor/edge_rails/*"].each do |path|
      $:.unshift("#{path}/lib") if File.directory?("#{path}/lib")
    end
    require "#{RAILS_ROOT}/vendor/edge_rails/railties/lib/initializer"
  else
    require 'rubygems'

    gem "rails", ENV['RAILS_VERSION']
    require 'initializer'
  end

  Rails::Initializer.run(:set_load_path)
end
