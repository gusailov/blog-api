FactoryBot.define do
  factory :comment do
    body { FFaker::Lorem.characters }
    article
  end
end
