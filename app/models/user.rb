class User < ApplicationRecord
  # validates :name, length: { minimum: 3 }
  # validates :name, format: { with: /[A-Z].*/,
  #                              message: "Первая буква должна быть заглавной" }
  # scope :users_with_created_orders, -> { select('user') }

  has_many :orders
  has_one :passport_data
end
