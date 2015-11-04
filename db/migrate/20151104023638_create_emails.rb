class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email_domain
      t.integer :bridge
      t.integer :bridge_global
      t.integer :email_frequency
      t.integer :month
      t.integer :year
      t.references :cluster, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
