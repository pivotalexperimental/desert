class ActiveRecord::Migrator
  module DesertMigrator
    def latest_version
      return 0 if migrations.empty?
      migrations.last.first
    end
  end
  include DesertMigrator
end
