password = Rails.application.credentials.seed[:test_user_password]

User.seed(:email) do |s|
  s.name = 'テストユーザ'
  s.email = 'test_user@example.com'
  s.password = password
  s.password_confirmation = password
  s.activated = true
  s.activated_at = Time.zone.now
end
