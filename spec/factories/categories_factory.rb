FactoryBot.define do
  factory :category do
    name { FFaker::Book.title }
  end
end
