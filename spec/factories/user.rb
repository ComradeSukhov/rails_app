FactoryBot.define do
  factory :user do
      sequence(:id, 1)
      name { 'Иван' }
      sequence(:surname, "Фамилия") 
      sequence(:balans, 10)
  end
end
  