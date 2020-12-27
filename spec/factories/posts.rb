FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Title#{n}" }
    sequence(:content) { |n| "content test-#{n}" }
    created_at { Time.zone.now }
    association :user

    trait :yesterday do
      content { 'yesterday' }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      content { 'day_before_yesterday' }
      created_at { 2.days.ago }
    end
  end
end
