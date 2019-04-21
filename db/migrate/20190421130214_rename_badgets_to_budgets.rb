class RenameBadgetsToBudgets < ActiveRecord::Migration[5.2]
  def change
    rename_table :badgets, :budgets
  end
end
