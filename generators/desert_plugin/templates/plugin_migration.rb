class Init<%= class_name %>Plugin < ActiveRecord::Migration
  def self.up
    create_table "<%= plural_name %>", :force => true do |t|
      t.column "some_<%= file_name %>_column", :string
    end
  end

  def self.down
    drop_table :<%= plural_name %>
  end
end
