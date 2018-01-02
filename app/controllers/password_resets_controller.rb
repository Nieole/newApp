class PasswordResetsController < ApplicationController
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
end
