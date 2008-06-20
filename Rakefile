require "rake"
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Runs the Rspec suite"
task(:default) do
  run_suite
end

desc "Runs the Rspec suite"
task(:spec) do
  run_suite
end

def run_suite
  dir = File.dirname(__FILE__)
  system("ruby #{dir}/spec/spec_suite.rb") || raise("Example Suite failed")
end

desc "Copies the trunk to a tag with the name of the current release"
task(:tag_release) do
  tag_release
end

PKG_NAME = "desert"
PKG_VERSION = "0.3.1"
PKG_FILES = FileList[
  '[A-Z]*',
  '*.rb',
  'lib/**/*.rb',
  'generators/**/*',
  'generators/**/templates/*',
  'examples/**/*.rb'
]

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Desert is a component framework for Rails that allows your plugins to be packaged as mini Rails apps."
  s.test_files = "examples/spec_suite.rb"
  s.description = s.summary

  s.files = PKG_FILES.to_a
  s.require_path = 'lib'

  s.has_rdoc = true
  s.extra_rdoc_files = [ "README.rdoc", "CHANGES" ]
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]

  s.test_files = Dir.glob('spec/*_spec.rb')
  s.require_path = 'lib'
  s.author = "Pivotal Labs"
  s.email = "opensource@pivotallabs.com"
  s.homepage = "http://pivotallabs.com"
  s.rubyforge_project = "pivotalrb"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

def tag_release
  dashed_version = PKG_VERSION.gsub('.', '-')
  svn_user = "#{ENV["SVN_USER"]}@" || ""
  `svn cp svn+ssh://#{svn_user}rubyforge.org/var/svn/pivotalrb/desert/trunk svn+ssh://#{svn_user}rubyforge.org/var/svn/pivotalrb/desert/tags/REL-#{dashed_version} -m 'Version #{PKG_VERSION}'`
end

desc "Install dependencies to run the build. This task uses Git."
task(:install_dependencies) do
  require "lib/desert/supported_rails_versions"
  system("git clone git://github.com/rails/rails.git spec/rails_root/vendor/rails_versions/edge")
  Dir.chdir("spec/rails_root/vendor/rails_versions/edge") do
    begin
      Desert::SUPPORTED_RAILS_VERSIONS.each do |version, data|
        unless version == 'edge'
          system("git checkout #{data['git_tag']}")
          system("cp -R ../edge ../#{version}")
        end
      end
    ensure
      system("git checkout master")
    end
  end
end

desc "Updates the dependencies to run the build. This task uses Git."
task(:update_dependencies) do
  system "cd spec/rails_root/vendor/rails_versions/edge; git pull origin"
end
