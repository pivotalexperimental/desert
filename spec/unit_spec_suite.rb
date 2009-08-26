class UnitSpecSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/desert/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

UnitSpecSuite.new.run
