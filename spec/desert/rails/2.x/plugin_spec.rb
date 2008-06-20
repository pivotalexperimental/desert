require File.expand_path("#{File.dirname(__FILE__)}/../../../spec_helper")

unless Desert::VersionChecker.rails_version_is_below_1990?
  module Rails
    describe Plugin, :shared => true do
      it_should_behave_like "Desert::Manager fixture"

      before do
        @configuration = Configuration.new
        @plugin = Rails::Plugin.new("#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy")
        @configuration = Configuration.new
        @initializer = Rails::Initializer.new(@configuration)
      end
    end

    describe Plugin, "#require_plugin" do
      it_should_behave_like "Rails::Plugin"

      it "raises error when passed a plugin that doesn't exist" do
        @plugin.load(@initializer)
        lambda do
          @plugin.require_plugin "i_dont_exist"
        end.should raise_error(RuntimeError, "Plugin 'i_dont_exist' does not exist")
      end
    end

    describe Plugin, "#load, when representing aa_depends_on_acts_as_spiffy" do
      it_should_behave_like "Rails::Plugin"

      it "evals init.rb which requires plugin dependencies and registers the plugin itself" do
        mock.proxy(@plugin).require_plugin('acts_as_spiffy')
        @plugin.load(@initializer)
        Desert::Manager.plugins.should == [
          Desert::Manager.find_plugin('the_grand_poobah'),
            Desert::Manager.find_plugin('acts_as_spiffy'),
            Desert::Manager.find_plugin('aa_depends_on_acts_as_spiffy'),
        ]
      end

      it "does not load an already-loaded plugin twice" do
        already_loaded_plugin = Rails::Plugin.new("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
        already_loaded_plugin.load(@initializer)

        Desert::Manager.plugins.should == [
          Desert::Manager.find_plugin('the_grand_poobah'),
            Desert::Manager.find_plugin('acts_as_spiffy')
        ]

        @plugin.load(@initializer)

        Desert::Manager.plugins.should == [
          Desert::Manager.find_plugin('the_grand_poobah'),
            Desert::Manager.find_plugin('acts_as_spiffy'),
            Desert::Manager.find_plugin('aa_depends_on_acts_as_spiffy'),
        ]
      end
    end
  end


end
