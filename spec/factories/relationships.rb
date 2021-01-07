FactoryBot.define do
  factory :follow_rel, class: 'Relationship' do
    association :followed_user,
                facrtory: :user
    association :user,
                factory: :user
    follower_id { followed_rel.user.id }
    followed_id { followed_rel.followed_user.id }
  end
end
