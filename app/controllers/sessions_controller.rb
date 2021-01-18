class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      @user.activated? ? success_login : no_activation
    else
      incorrect_login_info
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def guest_login
    @user = User.find_by(email: 'guest_user@example.com')
    log_in @user
    forget(@user)
    redirect_back_or @user
  end

  private

  def success_login
    log_in @user
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    redirect_back_or @user
  end

  def no_activation
    message = 'アカウントが有効化されていません。'
    message += '有効化リンクのメールを確認してください。'
    flash[:warning] = message
    redirect_to root_url
  end

  def incorrect_login_info
    flash.now[:danger] = 'ログイン情報が正しくありません。'
    render 'new'
  end
end
