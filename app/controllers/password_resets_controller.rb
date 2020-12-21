class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'パスワード再設定メールが送信されました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスが登録されていません。'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      success_update
    else
      render 'edit'
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  private

  def find_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  # 期限切れかどうかを確認する
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = 'パスワード再設定リンクの有効期限が切れています。'
    redirect_to new_password_reset_url
  end

  # update成功時の処理
  def success_update
    log_in @user
    @user.update_attribute(:reset_digest, nil)
    flash[:success] = 'パスワードを再設定しました。'
    redirect_to @user
  end
end
