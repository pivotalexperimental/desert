module SpiffyHelper
  class << self
    def duhh
      "duhh from project"
    end

    def loaded_project?
      true
    end

    def times_loaded
      @times_loaded ||= 0
    end
    attr_writer :times_loaded
  end
end
SpiffyHelper.times_loaded += 1