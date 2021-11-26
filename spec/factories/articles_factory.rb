FactoryBot.define do
  factory :article do
    title { FFaker::Book.title }
    body { FFaker::Lorem.sentences }
    category
  end
end
