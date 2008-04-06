class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :options => "ENGINE=MyISAM DEFAULT CHARSET=UTF8" do |t|
      t.column :login,      :string,    :limit => 20
      t.column :password,   :string,    :limit => 50
      t.column :role,       :integer
      t.column :e_mail,     :string,    :limit => 100
      t.column :firstname,  :string,    :limit => 100
      t.column :lastname,   :string,    :limit => 100
      t.column :cookie_hash,  :string,  :limit => 60
      t.column :created_at, :datetime
      # TODO Add address
    end
    add_index :users, :login
  end

  def self.down
    remove_index :users, :login
    drop_table :users
  end
end
