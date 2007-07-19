require "spec/spec_helper"

describe Object, :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"

  before do
    Object.const_defined?(:SpiffyHelper).should == false
    @fixture = Object.new
  end

  it "loads Compentized plugins" do
    Object.const_defined?(:SpiffyHelper).should == true
  end

  it "loads the project" do
    @fixture.loaded_project?.should be_true
  end
end

describe Object, " one plugin", :shared => true do
  it_should_behave_like "Object"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @fixture.extend SpiffyHelper
  end

  it "loads the plugin" do
    @fixture.loaded_acts_as_spiffy?.should be_true
  end

  it "lets the project override method from plugin" do
    @fixture.duhh.should == "duhh from project"
  end

  it "lets method defined in plugin stick around" do
    @fixture.im_spiffy.should == "im_spiffy from acts_as_spiffy"
  end
end

describe Object, " two plugins", :shared => true do
  it_should_behave_like "Object"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/super_spiffy"
    @fixture.extend SpiffyHelper
  end

  it "loads the both plugins" do
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.loaded_super_spiffy?.should be_true
  end

  it "lets the project override methods from both plugins" do
    @fixture.duhh.should == "duhh from project"
  end

  it "lets the later plugin override methods" do
    @fixture.im_spiffy.should == "im_spiffy from super_spiffy"
  end
end

describe Object, "#require with one plugin" do
  it_should_behave_like "Object one plugin"

  before do
    require 'spiffy_helper'
  end
end

describe Object, "#require with two plugins" do
  it_should_behave_like "Object two plugins"

  before do
    require 'spiffy_helper'
  end

  it "requires the files that the constant points to" do
    @fixture.extend SpiffyHelper
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.loaded_super_spiffy?.should be_true
    @fixture.duhh.should == "duhh from project"
    @fixture.im_spiffy.should == "im_spiffy from super_spiffy"
  end
end

describe Object, "#load with one plugin" do
  it_should_behave_like "Object one plugin"

  before do
    load 'spiffy_helper'
  end
end

describe Object, "#load with two plugins" do
  it_should_behave_like "Object two plugins"

  before do
    load 'spiffy_helper'
  end
end
