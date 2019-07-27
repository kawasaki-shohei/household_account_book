class UpdateLatestRepeatExpensesToVersion5 < ActiveRecord::Migration[5.2]
  def change
    update_view :latest_repeat_expenses, version: 5, revert_to_version: 4
  end
end
