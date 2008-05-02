dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

module ActionMailer
  describe Base, "#render template" do
    it "gives priority to the rails app" do
      @base = ::SpiffyMailer.create_spiffy_mail
      @base.body.should == "From App"
    end

    it "gives priority to plugins added later" do
      @base = ::SpiffyMailer.create_acts_as_spiffy
      @base.body.should == "From Super Spiffy"
    end
  end
end
