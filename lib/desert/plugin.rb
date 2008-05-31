module Desert
  class Plugin # nodoc
    attr_reader :name, :path
    def initialize(path)
      @path = File.expand_path(path)
      @name = File.basename(@path)
    end

    def migration_path
      "#{@path}/db/migrate"
    end

    # The path to the views for this plugin
    def templates_path
      "#{@path}/app/views"
    end

    def controllers_path
      "#{@path}/app/controllers"
    end

    # TODO: Test me
    def models_path
      "#{@path}/app/models"
    end

    # TODO: Test me
    def helpers_path
      "#{@path}/app/helpers"
    end

    # The path to the layout for this plugin
    def layouts_path
      "#{templates_path}/layouts"
    end

    # Finds a template with the specified path
    def find_template(template)
      template_path = "#{templates_path}/#{template}"
      File.exists?(template_path) ? template_path : nil
    end

    def framework_paths
      # TODO: Don't include dirs for frameworks that are not used
      %w(
        railties
        railties/lib
        actionpack/lib
        activesupport/lib
        activerecord/lib
        actionmailer/lib
        actionwebservice/lib
      ).map { |dir| "#{framework_root_path}/#{dir}" }.select { |dir| File.directory?(dir) }
    end

    def ==(other)
      self.path == other.path
    end

    def migration
      @migration ||= PluginMigrations::Migrator.new(:up, migration_path)
    end

    def with_current_plugin
      old_plugin = PluginMigrations::Migrator.current_plugin
      begin
        PluginMigrations::Migrator.current_plugin = self
        yield
      ensure
        PluginMigrations::Migrator.current_plugin = old_plugin
      end
    end
  end
end