class PasswordResetsController < ApplicationController
  before_action :get_user,only:[:edit,:update]
  before_action :valid_user,only:[:edit,:update]
  before_action :check_expiration,only:[:edit,:update]
  def new
  end

  def edit
  end
  #重置密码
  def create
    #通过email找到用户
    @user=User.find_by(email:params[:password_reset][:email].downcase)
    if @user
      #如果找到用户信息，则创建重置密码摘要
      @user.create_reset_digest
      @user.send_password_reset_email
      #当如闪现消息后跳转到首页
      flash[:info]="Email sent with password reset instructions"
      redirect_to root_url
    else
      #如果没有查到相关用户信息就跳转到注册页面并展示相关信息
      flash.now[:danger]="Email address not found"
      render 'new'
    end
  end

  def update
    #当更新密码为空时
    if params[:user][:password].empty?
      @user.errors.add(:password,"can't be empty")
      render 'edit'
    #密码更新成功
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest,nil)
      flash[:success]="Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  private
  #前置过滤器
  def get_user
    @user=User.find_by(email:params[:email])
  end
  #确保是有效用户
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset,params[:id])
      redirect_to root_url
    end
  end
  def user_params
    params.require(:user).permit(:password,:password_confirmation)
  end
  #检查重设令牌是否过期
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger]="Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
