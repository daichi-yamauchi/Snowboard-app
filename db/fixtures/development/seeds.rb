# メインのサンプルユーザーを1人作成する
User.seed(:email) do |s|
  s.name = 'Example User'
  s.email = 'example@railstutorial.org'
  s.password = 'aaaaaaaa'
  s.password_confirmation = 'aaaaaaaa'
  s.admin = true
  s.activated = true
  s.activated_at = Time.zone.now
end

# 追加のユーザーをまとめて生成する
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.seed(:email) do |s|
    s.name = name
    s.email = email
    s.password = password
    s.password_confirmation = password
    s.activated = true
    s.activated_at = Time.zone.now
  end
end

# ユーザーの一部を対象に投稿を生成する
users = User.order(:created_at).take(6)
n = 1
50.times do
  title = Faker::Lorem.words(number: 5).join
  content = Faker::Lorem.words(number: 50).join
  post_type = PostType.find_by(id: rand(2) + 1)
  users.each do |user|
    user.posts.seed do |s|
      s.id = n
      s.title = title
      s.content = content
      s.post_type = post_type
      n += 1
    end
  end
end

# 投稿の一部を対象にコメントを生成する
posts = Post.order(:created_at).take(6)
user_num = User.all.length
n = 1
posts.each do |post|
  5.times do
    content = Faker::Lorem.words(number: 20).join
    user = User.find_by(id: rand(user_num) + 1)
    post.comments.seed do |s|
      s.id = n
      s.user = user
      s.content = content
      n += 1
    end
  end
end

# 以下のリレーションシップを作成する
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each do |followed|
  Relationship.seed(:follower_id, :followed_id) do |s|
    s.follower_id = user.id
    s.followed_id = followed.id
  end
end

followers.each do |follower|
  Relationship.seed(:follower_id, :followed_id) do |s|
    s.follower_id = follower.id
    s.followed_id = user.id
  end
end
