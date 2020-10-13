class AddParamsToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :options, :json
  end
end
