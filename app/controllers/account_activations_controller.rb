class AccountActivationsController < ApplicationController
  #通过电子邮箱激活用户方法
  def edit
    user=User.find_by(email:params[:email])
    #如果用户存在并且用户没有被激活且token正确
    if user&&!user.activated?&&user.authenticated?(:activation,params[:id])
      #更新用户激活状态
      user.update_attribute(:activated,true)
      #更新用户激活时间
      user.update_attribute(:activated_at,Time.now)
      log_in user
      flash[:success]="Account activated!"
      redirect_to user
    else
      #如果验证不通过则跳转到首页
      flash[:danger]="Invalid activation link"
      redirect_to root_url
    end
  end
end
