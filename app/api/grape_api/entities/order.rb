class GrapeApi
  module Entities
    class Order < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :cost
      expose :created_at
      expose :user_id
    end
  end
end
    