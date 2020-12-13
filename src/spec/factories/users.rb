FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      admin { true }
    end
  end

  # factory :aaa do
  #   name { 'Test_admin' }
  #   email { 'test_admin@example.com' }
  #   password { 'password' }
  #   password_confirmation { 'password' }
  # end
end
