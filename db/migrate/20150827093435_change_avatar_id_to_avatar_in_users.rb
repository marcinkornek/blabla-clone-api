class ChangeAvatarIdToAvatarInUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :avatar_id
    add_column :users, :avatar, :string
  end

  def self.down
    add_column :users, :avatar_id, :integer
    remove_column :users, :avatar
  end
end
