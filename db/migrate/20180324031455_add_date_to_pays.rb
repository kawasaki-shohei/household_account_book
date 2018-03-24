class AddDateToPays < ActiveRecord::Migration[5.1]
  def change
    add_column :pays, :date, :date
    add_column :pays, :memo, :string
  end
end
