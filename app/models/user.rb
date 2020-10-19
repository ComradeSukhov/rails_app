class User < ApplicationRecord
  # validates :name, length: { minimum: 3 }
  # validates :name, format: { with: /[A-Z].*/,
  #                              message: "Первая буква должна быть заглавной" }
  # scope :users_with_created_orders, -> { select('user') }

  def self.created_orders_low_to_hi
    User.select(:name, 'SUM(cost) AS orders_sum')
        .joins(:orders)
        .group('users.name')
        .where("status = '1'")
        .order('orders_sum ASC')
  end

  has_many :orders
  has_one :passport_data
end
