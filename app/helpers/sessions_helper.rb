module SessionsHelper
  #将user_id存到session中
  def log_in user
    session[:user_id]=user.id
  end
  #返回当前会话中的@current_user，当为nil的时候通过session中储存的user_id到数据库中查询相关user信息
  def current_user
    # @current_user ||= User.find_by(id:session[:user_id])

    #如果session中有当前的：user_id，那么将其结果赋值给user_id并且执行当前分支的代码
    if user_id=session[:user_id]
      @current_user||=User.find_by(id:user_id)
    #如果cookies中有当前的:user_id，那么将其结果赋值给user_id并且执行当前分支的代码
    elsif user_id=cookies.signed[:user_id]
      user=User.find_by(id:user_id)
      #如果查到相关user信息并且cookies中的令牌与摘要匹配
      if user&&user.authenticated?(:remember,cookies[:remember_token])
        #调用SessionsHelper中的log_in方法
        log_in user
        #将查询到的user信息赋值给@current_user
        @current_user=user
      end
    end
  end
  #判断是否已经登录
  def logged_in?
    !current_user.nil?
  end
  #忘记用户方法
  def forget user
    #调用User中定义的forget方法
    user.forget
    #删除cookies中的user_id和remember_token
    cookies.delete :user_id
    cookies.delete :remember_token
  end
  #登出方法
  def log_out
    #调用SessionsHelper中定义的forget方法
    forget current_user
    session.delete(:user_id)
    @current_user=nil
  end
  #在持久会话中记住用户
  def remember user
    #调用User定义的remember方法
    user.remember
    #将user_id编码后放入cookies中并设置超时时间为20年
    cookies.permanent.signed[:user_id]=user.id
    #将remember_token放入cookies中并设置超时时间为20年
    cookies.permanent[:remember_token]=user.remember_token
    #cookies[:remember_token]={value:remember_token,expires:20.years.form_now.utc}
  end
  #如果指定用户是当前用户，返回true
  def current_user? user
    user==current_user
  end
  #重定向到储存的地址或默认地址
  def redirect_back_or default
    redirect_to (session[:forwarding_url]||default)
    session.delete(:forwarding_url)
  end
  #储存后面需要使用的地址
  def store_location
    #当请求为get方式时，将请求地址放入session中
    session[:forwarding_url]=request.original_url if request.get?
  end
end
