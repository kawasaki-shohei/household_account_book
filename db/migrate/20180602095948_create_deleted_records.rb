class CreateDeletedRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :deleted_records do |t|
      t.references :user, foreign_key: true
      t.string :table_name
      t.text :record_meta, null: false

      t.timestamps
    end
    rename_column :deleted_records, :user_id, :deleted_by
  end
end
