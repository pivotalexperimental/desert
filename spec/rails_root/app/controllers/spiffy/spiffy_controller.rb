class Spiffy::SpiffyController < ApplicationController
  class << self
    def project_loaded?
      true
    end

    def common_method
      "Project"
    end
  end

  def index
    render :nothing => true
  end
end