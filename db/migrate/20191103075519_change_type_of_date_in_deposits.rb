class ChangeTypeOfDateInDeposits < ActiveRecord::Migration[5.2]
  def up
    change_column :deposits, :date, :date
  end

  def down
    change_column :deposits, :date, :datetime
  end
end
