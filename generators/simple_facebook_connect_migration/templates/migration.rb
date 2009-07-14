class AddFacebookConnect < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_uid, :integer
    add_column :users, :email_hash, :string
    
    add_index :users, :fb_uid
    add_index :users, :email_hash
  end

  def self.down
    remove_index :users, :fb_uid
    remove_index :users, :email_hash

    remove_column :users, :email_hash
    remove_column :users, :fb_uid
  end
end
