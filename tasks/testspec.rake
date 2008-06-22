namespace :desert do
  namespace :testspec do
    Rake::TestTask.new("plugins") do |t|
      t.libs << "test"
      t.pattern = "vendor/plugins/#{ENV['PLUGIN'] || '**'}/**/*_test.rb"
      t.verbose = true
    end

    begin
      Spec::Rake::SpecTask.new("plugins") do |t|
        t.libs << "spec"
        t.pattern = "vendor/plugins/#{ENV['PLUGIN'] || '**'}/**/*_spec.rb"
      end
    rescue
      puts "You must install and/or require rspec to enable the desert spec tasks"
    end

    Rake::Task['desert:testspec:plugins'].comment = "Run the plugin tests and specs in vendor/plugins/** (or specify with PLUGIN=name)"

    desc "Test all plugins in config/plugins_to_test.yml"
    task :all_plugins do
      require "yaml"
      rake_plugins = YAML.load_file(RAILS_ROOT + "/config/plugins_to_test.yml")
      errored_plugins = []
      rake_plugins.each do |plugin|
        p "Testing plugin #{plugin}"
        cmd = "rake desert:testspec:plugins PLUGIN=#{plugin}"
        results = `#{cmd}`
        puts results
        lines = results.split("\n")

        found_status_line = false
        tests, specs, assertions, failures, errors = 0
        lines.reverse.each do |line|
          if matches = line.match(/(\d+) tests?, (\d+) assertions?, (\d+) failures?, (\d+) errors?/)
            found_status_line = true
            blah, tests, assertions, failures, errors = matches.to_a.collect {|match| match.to_i}
            break
          elsif matches = line.match(/(\d+) examples?, (\d+) failures?/)
            blah, specs, failures = matches.to_a.collect {|match| match.to_i}
            errors = 0
            found_status_line = true
            break
          end
        end
        raise "Could not find status line for plugin: #{plugin}" unless found_status_line
        errored_plugins << plugin if failures > 0 || errors > 0
      end
      raise "Test failures in the following plugins: #{errored_plugins.join(', ')}" unless errored_plugins.empty?
    end
  end
end
