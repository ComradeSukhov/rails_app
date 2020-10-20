class GrapeApi
  class OrdersApi < Grape::API # rubocop:disable Metrics/ClassLength
    format :json

    desc "Create a new order"

    namespace :orders do      
      # POST /api/orders
      params do
        requires :name, type: String
        requires :status, type: Integer
        requires :user_id, type: Integer
      end

      post do
        Order.create!({
          name: params[:name],
          status: params[:status],
          user_id: params[:user_id]
        })
      end

    desc "Get an order by ID"

      # GET /api/orders/:id
      route_param :id, type: Integer do
          
        get do
          order = Order.find(params[:id])
          error!({ message: 'Заказ не найден' }, 404) unless order
          present order, with: GrapeApi::Entities::Order
        end
      end

    desc "Update order"

      # PUT /api/orders/:id
      route_param :id, type: Integer do
        params do
          optional :name, type: String
          optional :status, type: String
          optional :cost, type: Integer
          optional :user_id, type: Integer
        end

        put do
          Order.find(params[:id]).update(params)
        end
      end

    desc "Delete order"

      # DELETE /api/orders/:id
      route_param :id, type: Integer do

        delete do
          Order.find(params[:id]).destroy!
        end
      end

    desc "Get a list of orders with the option to filter by status"

      # get /api/orders
      params do
        optional :status, type: String, desc: 'Status list:
                                               1 - unavailable,
                                               2 - created,
                                               3 - started,
                                               4 - failed,
                                               5 - removed'
      end

      get do
        if params[:status]
          orders = Order.where(status: params[:status])
          present orders, with: GrapeApi::Entities::Order, status: params[:status]
        else
          orders = Order.includes(:networks, :tags)
          present orders, with: GrapeApi::Entities::Order
        end
      end

    end
  end
end
  