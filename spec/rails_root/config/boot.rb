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
  if ENV['RAILS_VERSION']
    rails_dir = "#{RAILS_ROOT}/vendor/rails/#{ENV['RAILS_VERSION'].downcase}"
    Dir["#{rails_dir}/*"].each do |path|
      $:.unshift("#{path}/lib") if File.directory?("#{path}/lib")
    end
    raise "Edge Rails not in vendor. Run rake install_dependencies" unless  File.exists?("#{rails_dir}/railties/lib/initializer.rb")
    require "#{rails_dir}/railties/lib/initializer"
  else
    require 'rubygems'

    gem "rails", '2.0.2'
    require 'initializer'
  end

  Rails::Initializer.run(:set_load_path)
end
