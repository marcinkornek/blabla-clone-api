class AddFirstNameLastNameUidProviderTelNumBirthYearAvatarIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :tel_num, :string
    add_column :users, :birth_year, :string
    add_column :users, :avatar_id, :integer
  end
end
