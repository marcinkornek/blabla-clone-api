class ChangeCurrencyToIntegerInRides < ActiveRecord::Migration
  def up
    change_column :rides, :currency, 'integer USING CAST(currency AS integer)'
  end

  def down
    change_column :rides, :currency, :string
  end
end
