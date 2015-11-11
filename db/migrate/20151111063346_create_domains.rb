class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :url
      t.integer :sat_bridge
      t.references :cluster, index: true, foreign_key: true
      t.integer :global_bridge

      t.timestamps null: false
    end
  end
end
