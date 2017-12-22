class SessionsController < ApplicationController
  #获取登录页面
  def new
  end
  #登录方法
  def create
    #通过email查找用户表信息
    user=User.find_by email:params[:session][:email].downcase
    # debugger
    # 如果找到了user信息并且密码比对通过
    if user&&user.authenticate(params[:session][:password])
      #调用sessions_helper定义的log_in方法将user的id存入session
      log_in user
      #跳转到UsersController的show方法并传入user对象参数
      redirect_to user
    else
      #当用户信息验证不通过时放入一个单次有效的提示信息到flash里供页面展示
      flash.now[:danger]="Invalid email/password combination"
      #跳转到SessionsController的new方法刷新表单
      render 'new'
    end
  end
  #注销方法
  def destroy
    #调用sessions_helper定义的log_out方法将session中的user_id删除
    log_out
    #页面跳转到根路径
    redirect_to root_path
  end
end
