class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.string :cluster_name

      t.timestamps null: false
    end
  end
end
