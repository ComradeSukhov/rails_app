class AddUserRefToOrders < ActiveRecord::Migration[6.0]
  def up
    add_reference :orders, :user, foreign_key: true
    change_column :orders, :user_id, :integer, null: false
  end
  def down
    remove_column :orders, :user_id
  end
end
