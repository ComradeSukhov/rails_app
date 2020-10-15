class GrapeApi < Grape::API
  mount UsersApi
  mount OrdersApi
  add_swagger_documentation
end
  