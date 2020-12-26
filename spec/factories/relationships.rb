FactoryBot.define do
  # factory :relationship do
  #   association :user,
  #               factory: :user

  factory :follow_rel, class: 'Relationship' do
    association :followed_user,
                facrtory: :user
    association :user,
                factory: :user
    follower_id { followed_rel.user.id }
    followed_id { followed_rel.followed_user.id }
  end

  #   trait :followed do
  #     sequence(:follower_id) { |n| n }
  #     followed_id { 1 }
  #   end
  # end
end
