class UnitSpecSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/component_fu/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

if $0 == __FILE__
  UnitSpecSuite.new.run
end
