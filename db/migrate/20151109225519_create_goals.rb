class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :bridge_name
      t.integer :intensity
      t.integer :diversity
      t.integer :sat_bridge
      t.references :cluster, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
