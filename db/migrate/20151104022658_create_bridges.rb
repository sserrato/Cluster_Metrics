class CreateBridges < ActiveRecord::Migration
  def change
    create_table :bridges do |t|
      t.string :bridge
      t.integer :bridge_category
      t.integer :bridge_global

      t.timestamps null: false
    end
  end
end
