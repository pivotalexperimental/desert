require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe ActionView::Base do
  def load_rails_plugins
    configuration = Rails::Configuration.new
    initializer   = Rails::Initializer.new(configuration)
    loader = Rails::Plugin::Loader.new(initializer)
    loader.load_plugins
  end

  def register_all_plugins
    roots = []
    Dir["#{RAILS_ROOT}/vendor/plugins/*"].each do |dir|
      Desert::Manager.instance.register_plugin(dir) unless dir =~ /\.svn/
    end
  end

  unless Desert::VersionChecker.rails_version_is_below_230?
    before(:each) do
      load_rails_plugins
      register_all_plugins
    end

    it "should not duplicate plugin view paths when Engines present" do
      view = ActionView::Base.new(['vendor/plugins/acts_as_spiffy/app/views'])
      view.view_paths.select { |path| path.to_s =~ %r(vendor/plugins/acts_as_spiffy/app/views) }.length.should == 1
    end
  end
end
