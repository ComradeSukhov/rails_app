class GrapeApi
  class UsersApi < Grape::API # rubocop:disable Metrics/ClassLength
    format :json

    namespace :users do
        desc 'Список пользователей',
        success: GrapeApi::Entities::User,
        is_array: true

      params do
        optional :balans, type: Integer, desc: 'Баланс пользователя'
      end
      # GET /api/users
      get do
        users = if params[:balans].present?
          User.where('balans >= :balans', balans: params[:balans])
        else
          User.all
        end
        present users, with: GrapeApi::Entities::User
      end

      route_param :id, type: Integer do
        params do
            optional :detail, type: Boolean, desc: 'Подробная информация о пользователях'
        end
        # GET /api/users/:id
        get do
            user = User.find_by_id(params[:id])
            error!({ message: 'Пользователь не найден' }, 404) unless user
            present user, with: GrapeApi::Entities::User, detail: params[:detail]
        end

      end

      # POST /api/users
      params do
        requires :name, type: String, desc: 'Имя'
        requires :surname, type: String, desc: 'Фамилия'
        requires :balans, type: Integer, desc: 'Балланс'
      end
      post do
        user = User.create!(params)
        present user, with: GrapeApi::Entities::User, detail: true
      end

    end
  end
end
