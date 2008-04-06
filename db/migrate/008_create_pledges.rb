class CreatePledges < ActiveRecord::Migration
  def self.up
    create_table :pledges, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :user_id,      :integer,   :null => false
      t.column :action_id,    :integer,   :null => false
      t.column :status,       :integer,   :null => false, :default => 0
    end
    add_index :pledges, :user_id
    add_index :pledges, :action_id
    add_index :pledges, :status
  end

  def self.down
    remove_index :pledges, :user_id
    remove_index :pledges, :action_id
    remove_index :pledges, :status
    drop_table :pledges
  end
end
