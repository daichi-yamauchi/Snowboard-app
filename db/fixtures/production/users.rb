password = Rails.application.credentials.seed[:dummy_user_password]

User.seed(:email) do |s|
  s.name = 'まさなが'
  s.email = 'masanaga@example.com'
  s.password = password
  s.password_confirmation = password
  s.activated = true
  s.activated_at = Time.zone.now
end

User.seed(:email) do |s|
  s.name = '西井'
  s.email = 'nishii@example.com'
  s.password = password
  s.password_confirmation = password
  s.activated = true
  s.activated_at = Time.zone.now
end

User.seed(:email) do |s|
  s.name = 'からあげ'
  s.email = 'karaage@example.com'
  s.password = password
  s.password_confirmation = password
  s.activated = true
  s.activated_at = Time.zone.now
end

User.seed(:email) do |s|
  s.name = '鷲尾 直之'
  s.email = 'washio_naoyuki@example.com'
  s.password = password
  s.password_confirmation = password
  s.activated = true
  s.activated_at = Time.zone.now
end
