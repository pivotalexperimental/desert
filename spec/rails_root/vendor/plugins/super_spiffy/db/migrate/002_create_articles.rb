class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :title, :string, :null => false
      t.column :content, :text, :null => false
      t.column :author_id, :integer, :null => false
    end
  end
  
  def self.down
    drop_table :articles
  end
end