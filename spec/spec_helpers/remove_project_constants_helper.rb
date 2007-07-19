describe "Remove Project Constants", :shared => true do
  before do
    if Object.const_defined?(:SpiffyHelper)
      Object.send(:remove_const, :SpiffyHelper)
    end
  end
end