FactoryBot.define do
  factory :answer do
    user
    question
    body { "body answer" }

    trait :invalid do
      body { nil }
    end
  end
end
