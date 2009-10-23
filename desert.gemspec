# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{desert}
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pivotal Labs", "Brian Takita", "Parker Thompson", "Adam Milligan, Joe Moore"]
  s.date = %q{2009-10-23}
  s.description = %q{Desert is a component framework for Rails that allows your plugins to be packaged as mini Rails apps.}
  s.email = %q{opensource@pivotallabs.com}
  s.extra_rdoc_files = [
    "CHANGES",
     "README.rdoc"
  ]
  s.files = [
    "CHANGES",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "generators/desert_plugin/USAGE",
     "generators/desert_plugin/desert_plugin_generator.rb",
     "generators/desert_plugin/templates/desert_routes.rb",
     "generators/desert_plugin/templates/desert_routes.rb",
     "generators/desert_plugin/templates/empty_file",
     "generators/desert_plugin/templates/empty_file",
     "generators/desert_plugin/templates/plugin_migration.rb",
     "generators/desert_plugin/templates/plugin_migration.rb",
     "generators/desert_plugin/templates/spec_helper.rb",
     "generators/desert_plugin/templates/spec_helper.rb",
     "init.rb",
     "lib/desert.rb",
     "lib/desert/manager.rb",
     "lib/desert/plugin.rb",
     "lib/desert/plugin_migrations.rb",
     "lib/desert/plugin_migrations/1.2/extensions/schema_statements.rb",
     "lib/desert/plugin_migrations/1.2/migrator.rb",
     "lib/desert/plugin_migrations/2.1/extensions/schema_statements.rb",
     "lib/desert/plugin_migrations/2.1/migrator.rb",
     "lib/desert/plugin_migrations/migrator.rb",
     "lib/desert/plugin_templates.rb",
     "lib/desert/plugin_templates/1.2.0/action_mailer.rb",
     "lib/desert/plugin_templates/1.2.0/action_view.rb",
     "lib/desert/plugin_templates/1.99.0/action_mailer.rb",
     "lib/desert/plugin_templates/1.99.0/action_view.rb",
     "lib/desert/plugin_templates/2.0.0/action_mailer.rb",
     "lib/desert/plugin_templates/2.0.2/action_view.rb",
     "lib/desert/plugin_templates/2.1.0/action_view.rb",
     "lib/desert/plugin_templates/2.2.0/action_mailer.rb",
     "lib/desert/plugin_templates/2.2.0/action_view.rb",
     "lib/desert/plugin_templates/action_controller.rb",
     "lib/desert/plugin_templates/action_view.rb",
     "lib/desert/rails.rb",
     "lib/desert/rails/1.2.0/initializer.rb",
     "lib/desert/rails/2.0.0/plugin.rb",
     "lib/desert/rails/dependencies.rb",
     "lib/desert/rails/migration.rb",
     "lib/desert/rails/route_set.rb",
     "lib/desert/ruby.rb",
     "lib/desert/ruby/object.rb",
     "lib/desert/supported_rails_versions.rb",
     "lib/desert/tasks.rb",
     "lib/desert/version_checker.rb"
  ]
  s.homepage = %q{http://pivotallabs.com}
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{desert}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Desert is a component framework for Rails that allows your plugins to be packaged as mini Rails apps.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
