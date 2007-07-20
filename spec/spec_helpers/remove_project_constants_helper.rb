describe "Remove Project Constants", :shared => true do
  before do
    [
      :SpiffyHelper,
      :Spiffy,
      :ApplicationController,
    ].each do |mod_name|
      if Object.const_defined?(mod_name)
        Object.send(:remove_const, mod_name)
      end
    end
    $".delete_if {|path| path.include?('spiffy_helper')}
    Dependencies.load_once_paths.clear
  end
end