FactoryBot.define do
  factory :answer do
    question
    body { "MyString" }
    correct { false }

    trait :invalid do
      body { nil }
    end
  end
end
