class CreateNeeds < ActiveRecord::Migration
  def self.up
    create_table :needs, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :need_type,  :integer,   :null => false
      t.column :desc,       :string,    :limit => 200
      t.column :local,      :boolean,   :null => false
      t.column :project_id, :integer,   :null => false
    end
    add_index :needs, :project_id
  end

  def self.down
    remove_index :needs, :project_id
    drop_table :needs
  end
end
