class AddCurrencyToRides < ActiveRecord::Migration
  def change
    add_column :rides, :currency, :string
  end
end
