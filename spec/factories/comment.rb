FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "comment test-#{n}" }
    created_at { Time.zone.now }
    association :user
    association :post

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
