module Spiffy
  class SpiffyController < ::ApplicationController
    class << self
      def acts_as_spiffy_loaded?
        true
      end

      def common_method
        "Acts As Spiffy"
      end
    end
    helper :controller_requested

    def acts_as_spiffy
      render :text => "Acting Spiffy"
    end
  end
end