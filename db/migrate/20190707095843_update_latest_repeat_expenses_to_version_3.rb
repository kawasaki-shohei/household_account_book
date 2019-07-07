class UpdateLatestRepeatExpensesToVersion3 < ActiveRecord::Migration[5.2]
  def change
    update_view :latest_repeat_expenses, version: 3, revert_to_version: 2
  end
end
