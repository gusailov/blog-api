FactoryBot.define do
  factory :comment do
    body { FFaker::Lorem.sentence }
    article
  end
end
