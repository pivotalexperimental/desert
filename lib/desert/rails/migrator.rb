class ActiveRecord::Migrator
  module DesertMigrator
    def latest_version
      return 0 if migration_classes.empty?
      migration_classes.last.first
    end

    def migration_classes_with_caching
      @migration_classes ||= migration_classes_without_caching
    end
  end
  include DesertMigrator
  alias_method_chain :migration_classes, :caching
end
