class GrapeApi
  module Entities
    class Order < Grape::Entity
      expose :name
      expose :created_at
      expose :networks_count
      expose :tags
      expose :status, if: lambda { |object, options| options[:status] }

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
  end
end
    