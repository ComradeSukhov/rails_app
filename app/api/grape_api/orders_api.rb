class GrapeApi
  class OrdersApi < Grape::API # rubocop:disable Metrics/ClassLength
    format :json

    namespace :orders do      
      # POST /api/orders
      params do
        optional :name, type: String
        optional :surname, type: String
        optional :balans, type: Integer
      end

      post do
        # POST /api/users
          Order.create!({
            name:params[:name],
            status:params[:status],
            cost:params[:cost],
            user_id:params[:user_id]
          })
        end

        # read do

        # end

        # update do

        # end

        # delete do

        # end
    end
  end
end
  