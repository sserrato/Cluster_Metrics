class RenameColumnUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
    t.rename :user_email, :email
  end
  end
end
