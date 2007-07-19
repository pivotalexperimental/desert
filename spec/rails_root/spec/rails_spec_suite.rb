class RailsSpecSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

if $0 == __FILE__
  RailsSpecSuite.new.run
end
