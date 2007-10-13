dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

module ActionView
describe Base, "#render partial" do
  before do
    @controller = ::Spiffy::SpiffyController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @controller.send(:initialize_template_class, @response)
    @controller.send(:assign_shortcuts, @request, @response)
    @base = ActionView::Base.new("#{RAILS_ROOT}/app/views", {}, @controller)
  end

  it "gives priority to the rails app" do
    @base.render(:partial => "spiffy").should == "From App"
  end

  it "gives priority to plugins added later" do
    @base.render(:partial => "acts_as_spiffy").should == "From Super Spiffy"
  end
end
end
