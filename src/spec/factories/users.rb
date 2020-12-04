FactoryBot.define do
  factory :user do
    name { 'Example User' }
    email { 'user@example.com' }
    password { 'a' * 8 }
    password_confirmation { 'a' * 8 }
  end
end
