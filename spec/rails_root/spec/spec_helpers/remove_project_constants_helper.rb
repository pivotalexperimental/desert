describe "Remove Project Constants", :shared => true do
  before do
    if Object.const_defined?(:RetardedHelper)
      Object.send(:remove_const, :RetardedHelper)
    end
  end
end