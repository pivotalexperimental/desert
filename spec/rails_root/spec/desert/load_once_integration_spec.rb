require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

describe Module, "#const_missing load once path" do
  it_should_behave_like "Remove Project Constants"

  it "loads files on the load_once path the first time" do
    LoadMeOnce.should be_loaded
  end
end