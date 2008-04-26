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
    rails_versions_dir = "#{RAILS_ROOT}/vendor/rails_versions/#{ENV['RAILS_VERSION'].downcase}"
    rails_dir = "#{RAILS_ROOT}/vendor/rails"

    system("rm -f #{rails_dir}")
    system("ln -s #{rails_versions_dir} #{rails_dir}")

    Dir["#{rails_dir}/*"].each do |path|
      $:.unshift("#{path}/lib") if File.directory?("#{path}/lib")
    end
    raise "Edge Rails not in vendor. Run rake install_dependencies" unless  File.exists?("#{rails_dir}/railties/lib/initializer.rb")

    if ENV['RAILS_VERSION'] == "EDGE"
      require "#{rails_dir}/railties/environments/boot"
    else
      require "#{rails_dir}/railties/lib/initializer"
    end
  else
    require 'rubygems'

    gem "rails", '2.0.2'
    require 'initializer'
  end

  Rails::Initializer.run(:set_load_path)
end
