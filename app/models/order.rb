class Order < ApplicationRecord

  # validates :name, length: { maximum: 10 }

  before_create :set_cost

  scope :high_cost, -> { where(cost: 1_000..) }
  scope :vip_failed, -> { failed.high_cost }
  scope :created_before, -> (time) { where('created_at < ?', time)}

  def set_cost
    self.cost = rand(1000)
  end

  enum status: %w[unavailable created started failed removed]

  belongs_to :user
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :networks
end
