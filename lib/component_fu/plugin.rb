module ComponentFu
  class Plugin
    attr_reader :name, :path
    def initialize(path)
      @path = File.expand_path(path)
      @name = File.basename(@path)
    end

    def migration_path
      "#{@path}/db/migrate"
    end

    def ==(other)
      self.path == other.path
    end
  end
end