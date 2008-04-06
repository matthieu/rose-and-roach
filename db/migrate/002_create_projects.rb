class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :name,       :string,  :limit => 100,   :null => false
      t.column :desc,       :text
      t.column :short_desc, :string,  :limit => 200
      # TODO Add localization
    end
  end

  def self.down
    drop_table :projects
  end
end
