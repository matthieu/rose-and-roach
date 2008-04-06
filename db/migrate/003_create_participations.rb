class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :part_type,     :integer, :null => false
      t.column :quantity, :decimal, :precision => 14, :scale => 2
      t.column :user_id,  :integer, :null => false
      t.column :need_id,  :integer, :null => false
    end
    add_index :participations, :user_id
    add_index :participations, :need_id
  end

  def self.down
    remove_index :participations, :user_id
    remove_index :participations, :need_id
    drop_table :participations
  end
end
