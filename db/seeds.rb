# メインのサンプルユーザーを1人作成する
User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'aaaaaaaa',
             password_confirmation: 'aaaaaaaa',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# 投稿タイプを作成
PostType.create!(name: 'article', name_j: '記事')
PostType.create!(name: 'question', name_j: '質問')

# ユーザーの一部を対象に投稿を生成する
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(word_count: 20)
  content = Faker::Lorem.sentence(word_count: 200)
  post_type = PostType.find_by(id: rand(2) + 1)
  users.each { |user| user.posts.create!(title: title, content: content, post_type: post_type) }
end
