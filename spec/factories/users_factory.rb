FactoryBot.define do
  factory :user do
    email { FFaker::Internet.free_email }
    password { "12345678" }
    password_confirmation { "12345678" }

    trait :admin do
      role { :admin }
    end
  end
end
