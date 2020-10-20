class User < ApplicationRecord
  # validates :name, :surname, length: { minimum: 3 }
  # validates :name, :surname, format: { with: /\A[А-ЯA-Z].*\z/,
  #                            message: "Первая буква должна быть заглавной" }
  # validates :name, :surname, format: { with: /\A[а-яА-Я].*\z/,
  #                            message: "Элементы имени должны содержать только русские символы" }

  scope :users_with_orders, -> (by_order = 'ASC') {  select(:id,
                                                            :name,
                                                            'SUM(cost) AS orders_sum')
                                                     .joins(:orders)
                                                     .group(:id, 'users.name')
                                                     .where("status = '1'")
                                                     .order("orders_sum #{by_order}")
                                                     .preload('orders')
                                                  }

  def self.show_users_with_orders(by_order = 'ASC')
    users_with_orders(by_order).each do |user|

      puts "Имя пользователя: #{user.name}"
      puts "Сумма заказов #{user.orders_sum}"
      
      user.orders.each do |order|
        next unless order.status == 'created'
        puts "\n"
        puts "Имя заказа: #{order.name}"
        puts "Статус заказа: #{order.status}"
        puts "Стоимость заказа: #{order.cost}"
      end
      puts '--------'
    end
  end

  has_many :orders
  has_one :passport_data
end
