FactoryBot.define do
  factory :like_post_relationship do
    created_at { Time.zone.now }
    association :user, factory: :user
    association :post, factory: :post

    trait :yesterday do
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      created_at { 2.days.ago }
    end
  end
end
