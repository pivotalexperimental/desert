module Spiffy
  class SpiffyController < ApplicationController
    class << self
      def super_spiffy_loaded?
        true
      end

      def common_method
        "Super Spiffy"
      end
    end

    def super_spiffy
      render :text => "Im super spiffy"
    end
  end
end