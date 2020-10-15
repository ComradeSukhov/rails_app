class GrapeApi
  module Entities
    class User < Grape::Entity
      expose :id
      expose :full_name
      expose :balans, if: lambda { |object, options| options[:detail] == true } 

      def full_name
        "#{object.name} #{object.surname}"
      end
    end
  end
end
  