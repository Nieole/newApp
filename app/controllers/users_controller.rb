class UsersController < ApplicationController
  #获取user注册页面
  def new
    @user=User.new
  end
  #获取展示user信息页面
  def show
  	@user=User.find(params[:id])
  	# debugger
  end
  #注册user方法
  def create
    #通过页面表单传入参数新增user
    @user=User.new(user_params)
    # debugger
    #判断@user保存是否成功
    if @user.save
      #保存成功时调用调用sessions_helper定义的log_in方法将user的id存入session
      log_in @user
      #将注册成功消息放入flash供页面展示
      flash[:success]="Welcome to the Sample App!"
      #页面跳转到user_url并带入@user参数
      redirect_to @user
      # redirect_to user_url(@user)
    else
      #当保存失败时重定向到new方法获取user注册页面
      render 'new'
    end
  end
  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
