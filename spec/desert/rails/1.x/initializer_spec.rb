require File.expand_path("#{File.dirname(__FILE__)}/../../../spec_helper")

if Desert::VersionChecker.rails_version_is_below_1990?
  module Rails
    describe Initializer, :shared => true do
      it_should_behave_like "Desert::Manager fixture"

      before do
        @configuration = Configuration.new
        @initializer = Rails::Initializer.new(@configuration)
        class << @initializer
          public :load_plugin
        end

        mock_plugin = 'mock plugin'
      end
    end

    describe Initializer, "#load_plugin" do
      it_should_behave_like "Rails::Initializer"

      it "adds the plugin to the plugins registry" do
        dir = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
        @initializer.load_plugin dir
        Desert::Manager.find_plugin('acts_as_spiffy').should_not be_nil
      end
    end

    describe Initializer, "#require_plugin" do
      it_should_behave_like "Rails::Initializer"

      it "raises error when passed a plugin that doesn't exist" do
        lambda do
          @initializer.require_plugin "i_dont_exist"
        end.should raise_error(RuntimeError, "Plugin 'i_dont_exist' does not exist")
      end

      it "adds the plugin to the plugins registry" do
        @initializer.load_plugin "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy"
        Desert::Manager.plugins.should == [
          Desert::Manager.find_plugin('the_grand_poobah'),
          Desert::Manager.find_plugin('acts_as_spiffy'),
          Desert::Manager.find_plugin('aa_depends_on_acts_as_spiffy'),
        ]
      end

      it "does not add plugin twice" do
        @initializer.load_plugin "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
        @initializer.load_plugin "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy"

        Desert::Manager.plugins.should == [
          Desert::Manager.find_plugin('the_grand_poobah'),
          Desert::Manager.find_plugin('acts_as_spiffy'),
          Desert::Manager.find_plugin('aa_depends_on_acts_as_spiffy'),
        ]
      end
    end
  end

end