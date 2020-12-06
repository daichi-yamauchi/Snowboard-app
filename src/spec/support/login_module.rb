module LoginModule
  def login(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  # テストユーザーがログイン中の場合にtrueを返す
  def logged_in?
    !session[:user_id].nil?
  end
end
