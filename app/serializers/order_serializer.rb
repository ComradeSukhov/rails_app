class OrderSerializer < ActiveModel::Serializer
  attributes :name, :created_at, :networks_count, :tags

  def networks_count
    "#{object.networks.size}"
  end

  def tags
    object.tags.select(:id,:name)
  end
end
