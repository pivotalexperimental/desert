describe "Remove Project Constants", :shared => true do
  before do
    if Object.const_defined?(:SpiffyHelper)
      Object.send(:remove_const, :SpiffyHelper)
    end
    $".delete_if {|path| path.include?('spiffy_helper')}
    Dependencies.load_once_paths.clear
  end
end