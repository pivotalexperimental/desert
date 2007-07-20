module Spiffy
  class SpiffyController < ApplicationController
    class << self
      def acts_as_spiffy_loaded?
        true
      end

      def common_method
        "Acts As Spiffy"
      end
    end
  end
end