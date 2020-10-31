class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :quantity
      t.string :hdd_type
      t.text :body

      t.timestamps
    end
  end
end
