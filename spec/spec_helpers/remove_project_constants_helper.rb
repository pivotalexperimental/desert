describe "Remove Project Constants", :shared => true do
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
    Dependencies.load_once_paths.clear
    Dependencies.loaded.clear
  end
end