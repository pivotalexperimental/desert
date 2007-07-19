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
end

describe Object, " one plugin", :shared => true do
  it_should_behave_like "Object"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
  end

  it "requires files from one plugin" do
    @fixture.extend SpiffyHelper
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.duhh.should == "duhh from acts_as_spiffy"
  end
end

describe Object, " two plugins", :shared => true do
  it_should_behave_like "Object"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/super_spiffy"
  end

  it "requires the files that the constant points to" do
    @fixture.extend SpiffyHelper
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.loaded_super_spiffy?.should be_true
    @fixture.duhh.should == "duhh from super_spiffy"
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
    @fixture.duhh.should == "duhh from super_spiffy"
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

  it "requires the files that the constant points to" do
    @fixture.extend SpiffyHelper
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.loaded_super_spiffy?.should be_true
    @fixture.duhh.should == "duhh from super_spiffy"
  end
end