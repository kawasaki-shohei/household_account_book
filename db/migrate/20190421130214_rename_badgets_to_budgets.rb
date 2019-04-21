class RenameBadgetsToBudgets < ActiveRecord::Migration[5.2]
  def change
    rename_table :budgets, :budgets
  end
end
