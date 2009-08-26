require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module ActionController
  describe Base, "#render" do
    include ActionController::UrlWriter

    before do
      # TODO: fix the pending tests.  This block references Cgi stuff that is not the same across Rails versions.
      #ENV["REQUEST_URI"] = super_spiffy_path
      #ENV["REQUEST_METHOD"] = "GET"
      #ENV["REMOTE_ADDR"] = "127.0.0.0"
      #ENV["HTTP_HOST"] = 'test.host'
      #cgi = CGI.new
      #@request = ActionController::CgiRequest.new(cgi, {})
      #@response = ActionController::CgiResponse.new(cgi)
      #@response.template
      #
      #@controller = ::Spiffy::SpiffyController.new
      #@controller.request = @request
      #@controller.response = @response
    end

    it "gives priority to the rails app" do
      pending
      @controller.process(@request, @response, :render, :template => "spiffy/spiffy/spiffy")
      @response.body.should == "From App"
    end

    it "gives priority to plugins added later" do
      pending
      @controller.process(@request, @response, :render, :template => "spiffy/spiffy/acts_as_spiffy")
      @response.body.should == "From Super Spiffy"
    end
  end
end
