class SpecSuite
  def run
    dir = File.dirname(__FILE__)
    require "#{dir}/../lib/desert/supported_rails_versions"
    versions = Desert::SUPPORTED_RAILS_VERSIONS.keys.sort.reverse
    versions.each do |rails_version|
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
    system("export RAILS_VERSION=#{rails_version} && ruby #{suite_path}") ||
      raise("Failed for version #{rails_version}")
  end
end

if $0 == __FILE__
  SpecSuite.new.run
end