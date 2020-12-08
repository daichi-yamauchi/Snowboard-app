module LoginModule
  def login(user, email: user.email, password: 'password', remember_me: '1')
    visit login_path
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    check 'ログインしたままにする' if remember_me == '1'
    click_button 'ログイン'
  end

  # テストユーザーとしてログインする
  def post_login(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                         password: password,
                                         remember_me: remember_me } }
  end

  # テストユーザーがログイン中の場合にtrueを返す
  def logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする
  def login_direct(user)
    session[:user_id] = user.id
  end
end
