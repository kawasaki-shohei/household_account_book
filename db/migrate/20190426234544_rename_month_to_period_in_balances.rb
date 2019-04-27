class RenameMonthToPeriodInBalances < ActiveRecord::Migration[5.2]
  def change
    rename_column :balances, :month, :period
  end
end
