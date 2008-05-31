require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module ActionView
  describe Base, "#render partial" do
    before do
      @controller = ::Spiffy::SpiffyController.new
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      @controller.send(:initialize_template_class, @response)
      @controller.send(:assign_shortcuts, @request, @response)
      if ActionView::Base.instance_methods.include?('base_path')
        @base = ActionView::Base.new(["#{RAILS_ROOT}/app/views"], {}, @controller)
      else
        @base = ActionView::Base.new("#{RAILS_ROOT}/app/views", {}, @controller)
      end
    end

    it "gives priority to the rails app" do
      @controller.send(:render_to_string, :template => "spiffy/spiffy/spiffy").should == "From App"
      @base.render(:partial => "spiffy").should == "From App"
    end

    it "gives priority to plugins added later" do
      @base.render(:partial => "acts_as_spiffy").should == "From Super Spiffy"
    end
  end
end
