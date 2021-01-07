FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end

    trait :inactive do
      activated { false }
      activated_at { nil }
    end

    trait :has_posts do
      after(:create) do |user|
        create(:post, user: user)
      end
    end

    trait :has_relationship do
      after(:create) do |user|
        following = create_list(:user, 5)
        following.each do |target|
          user.follow(target)
        end
        follower = create_list(:user, 5)
        follower.each do |target|
          target.follow(user)
        end
      end
    end
  end
end
