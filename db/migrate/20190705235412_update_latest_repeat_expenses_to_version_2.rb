class UpdateLatestRepeatExpensesToVersion2 < ActiveRecord::Migration[5.2]
  def change
    update_view :latest_repeat_expenses, version: 2, revert_to_version: 1
  end
end
