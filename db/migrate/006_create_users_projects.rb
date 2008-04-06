class CreateUsersProjects < ActiveRecord::Migration
  def self.up
    create_table :users_projects, :id => false, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :project_id,   :integer,   :null => false
      t.column :user_id,      :integer,   :null => false
    end
    add_index :users_projects, [:project_id, :user_id]
    add_index :users_projects, :user_id
  end

  def self.down
    remove_index :users_projects, [:project_id, :user_id]
    remove_index :users_projects, :user_id
    drop_table :users_projects
  end
end
