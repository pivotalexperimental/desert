class SpecSuite
  def run
    dir = File.dirname(__FILE__)
    ["2.0.2", "1.99.0", "1.2.5"].each do |rails_version|
      [
        "#{dir}/unit_spec_suite.rb",
        "#{dir}/rails_root/spec/rails_spec_suite.rb"
      ].each do |suite_file|
        puts "Running #{suite_file} for Rails version #{rails_version}"
        run_with_rails_version(suite_file, rails_version) ||
          "Suite failed for Rails version #{rails_version}"
      end
    end
  end

  protected
  def run_with_rails_version(suite_path, rails_version)
    cmd = %Q|require "rubygems"; | <<
          %Q|gem "rails", "=#{rails_version}";| <<
          %Q|load "#{suite_path}";|
    system("ruby -e '#{cmd}'")
  end
end

if $0 == __FILE__
  SpecSuite.new.run
end