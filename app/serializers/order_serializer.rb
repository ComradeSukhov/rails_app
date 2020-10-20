class OrderSerializer < ActiveModel::Serializer
  attributes :name, :created_at, :networks_count, :tags

  def networks_count
    "#{object.networks.size}"
  end

  def tags
    tags = []

    object.tags.each do |tag|
      tags << { id: tag.id, name: tag.name }
    end
    tags
  end
end
