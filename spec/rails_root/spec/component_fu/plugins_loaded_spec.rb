dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe "Desert plugins" do
  it "registers all plugins" do
    Desert::ComponentManager.plugin_exists?('acts_as_spiffy').should be_true
    Desert::ComponentManager.plugin_exists?('super_spiffy').should be_true
  end
end