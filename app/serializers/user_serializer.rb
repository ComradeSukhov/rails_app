class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name
  
  def full_name
    "#{object.surname} #{object.name}"
  end
end
  