FactoryBot.define do
  factory :answer do
    user
    question
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
