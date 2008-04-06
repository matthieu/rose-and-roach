class CreateSavings < ActiveRecord::Migration
  def self.up
    create_table :savings, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :saving_type,  :integer,   :null => false
      t.column :desc,         :string,    :limit => 200
      t.column :unit,         :integer
      t.column :quantity,     :float
      t.column :project_id,   :integer,   :null => false
    end
    add_index :savings, :project_id
  end

  def self.down
    remove_index :savings, :project_id
    drop_table :savings
  end
end
