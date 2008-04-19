module Desert
  describe Manager, " fixture", :shared => true do
    it_should_behave_like "Remove Project Constants"
    before do
      @original_manager = Manager.instance
      @manager = Manager.new
      Manager.instance = @manager
    end

    after do
      Manager.instance = @original_manager
    end
  end
end