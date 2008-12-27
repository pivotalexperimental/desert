require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module ActiveRecord
  describe Migration do
    describe "#migrate_plugin" do
      before do
        drop_tables
      end

      after do
        drop_tables
      end

      if ActiveRecord::Migrator.respond_to?(:schema_migrations_table_name)
        describe "after 2.0.2" do
          it "creates plugin schema migrations table" do
            Migration.migrate_plugin('acts_as_spiffy', 2)
            results = select("select * from plugin_schema_migrations;")
            results.should == [
              {
                'plugin_name' => 'acts_as_spiffy',
                'version' => '1'
              },
              {
                'plugin_name' => 'acts_as_spiffy',
                'version' => '2'
              },
            ]
          end

          it "migrates the data" do
            Migration.migrate_plugin('acts_as_spiffy', 2)
            table_names = ActiveRecord::Base.connection.tables
            table_names.sort.should == [
              "companies",
              "employees",
              "plugin_schema_migrations",
              "schema_migrations"
            ].sort
          end

          it "converts from pre 2.0.2 style migrations" do
            execute_sql("CREATE TABLE #{Desert::PluginMigrations::Migrator.schema_info_table_name} (plugin_name #{type_to_sql(:string)}, version #{type_to_sql(:integer)})")
            execute_sql(sanitize_sql([
              "insert into #{Desert::PluginMigrations::Migrator.schema_info_table_name}(plugin_name, version) values(?, ?)",
              "super_spiffy",
              3
            ]))
            execute_sql(sanitize_sql([
              "insert into #{Desert::PluginMigrations::Migrator.schema_info_table_name}(plugin_name, version) values(?, ?)",
              "acts_as_spiffy",
              2
            ]))

            migrator = Migrator.new(nil, nil)
            result = select("select plugin_name, version from #{Desert::PluginMigrations::Migrator.schema_migrations_table_name}")
            result.length.should == 5
            result.should include({"plugin_name" => "super_spiffy", "version" => "1"})
            result.should include({"plugin_name" => "super_spiffy", "version" => "2"})
            result.should include({"plugin_name" => "super_spiffy", "version" => "3"})
            result.should include({"plugin_name" => "acts_as_spiffy", "version" => "1"})
            result.should include({"plugin_name" => "acts_as_spiffy", "version" => "2"})
          end
        end
      else
        describe "up to 2.0.2" do
          it "creates plugin schema info table" do
            Migration.migrate_plugin('acts_as_spiffy', 2)
            results = select("select * from plugin_schema_info;")
            results.should == [
              {
                'plugin_name' => 'acts_as_spiffy',
                'version' => '2'
              },
            ]
          end

          it "migrates the data" do
            Migration.migrate_plugin('acts_as_spiffy', 2)
            table_names = ActiveRecord::Base.connection.tables
            table_names.should include('companies')
            table_names.should include('employees')
            table_names.should include('plugin_schema_info')
            table_names.should include('schema_info')
          end
        end
      end

      it "raises error when invalid plugin name passed in" do
        lambda do
          Migration.migrate_plugin('acts_as_absent', 2)
        end.should raise_error(ArgumentError, "No plugin found named acts_as_absent")
      end

      def drop_tables
        tables = ActiveRecord::Base.connection.tables - ['sqlite_sequence']
        tables.each do |table_name|
          execute_sql "drop table `#{table_name}`"
        end
      end

      def select(sql)
        result_set = []
        stream = execute_sql(sql)
        if stream.respond_to?(:each_hash)
          stream.each_hash do |hash|
            result_set << hash
          end
        else
          stream.each do |hash|
            result_set << {'plugin_name' => hash['plugin_name'], 'version' => hash['version']}
          end
        end
        result_set
      end

      def execute_sql(sql)
        Base.connection.execute(sql)
      end

      def sanitize_sql(*args)
        ActiveRecord::Base.send(:sanitize_sql, *args)
      end

      def type_to_sql(type)
        ActiveRecord::Base.connection.type_to_sql(type)
      end
    end
  end
end
