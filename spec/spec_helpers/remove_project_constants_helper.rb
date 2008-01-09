describe "Remove Project Constants", :shared => true do
  attr_reader :original_dependencies_load_once_paths, :original_dependencies_load_paths, :original_loaded_paths
  before do
    [
      :SpiffyHelper,
      :Spiffy,
      :ApplicationController,
      :ApplicationHelper,
      :LibModule
    ].each do |mod_name|
      if Object.const_defined?(mod_name)
        Object.send(:remove_const, mod_name)
      end
    end
    Dependencies.autoloaded_constants.clear
    $".delete_if {|path| path.include?('spiffy_helper')}
    @original_dependencies_load_once_paths = Dependencies.load_once_paths
    @original_dependencies_load_paths = Dependencies.load_paths
    @original_loaded_paths = Dependencies.loaded.clear
  end

  after do
    Dependencies.load_once_paths = original_dependencies_load_once_paths
    Dependencies.load_paths = original_dependencies_load_paths
    Dependencies.loaded = original_loaded_paths
  end
end