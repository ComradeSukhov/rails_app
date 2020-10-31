class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :type, :body
end
