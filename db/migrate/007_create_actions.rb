class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :name,         :string,    :null => false
      t.column :project_id,   :integer,   :null => false
      t.column :classifier,   :integer,   :null => false, :default => 0
      t.column :saving_type,  :integer
      t.column :desc,         :text
      t.column :unit,         :integer
      t.column :quantity,     :float
    end
    add_index :actions, :classifier
    add_index :actions, :project_id
  end

  def self.down
    remove_index :actions, :classifier
    remove_index :actions, :project_id
    drop_table :actions
  end
end
