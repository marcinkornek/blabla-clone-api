class RemoveBirthYearFromUsers < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :users, :birth_year
  end

  def self.down
    add_column :users, :birth_year, :string
  end
end
