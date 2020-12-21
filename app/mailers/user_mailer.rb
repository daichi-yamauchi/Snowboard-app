class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: '【スノメン】アカウントの有効化'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: '【スノメン】パスワードの再設定'
  end
end
