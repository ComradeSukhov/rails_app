class Order < ApplicationRecord

  # validates :name, length: { maximum: 10 }

  # before_create :set_cost, on: [:update, :create]

  def set_cost
    self.cost = rand(100)
  end

  enum status: %w[unavailable created started failed removed]

  belongs_to :user
end
