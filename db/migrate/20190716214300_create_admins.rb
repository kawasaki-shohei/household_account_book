class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.index ["email"], name: "index_admins_on_email", unique: true

      t.timestamps
    end
  end
end
