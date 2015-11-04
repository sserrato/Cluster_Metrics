class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :access_permission
      t.string :user_email
      t.string :password_digest
      t.references :cluster, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
