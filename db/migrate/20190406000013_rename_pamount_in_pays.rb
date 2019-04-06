class RenamePamountInPays < ActiveRecord::Migration[5.2]
  def change
    rename_column :pays, :pamount, :amount
  end
end
