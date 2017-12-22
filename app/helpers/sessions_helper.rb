module SessionsHelper
  #将user_id存到session中
  def log_in user
    session[:user_id]=user.id
  end
  #返回当前会话中的@current_user，当为nil的时候通过session中储存的user_id到数据库中查询相关user信息
  def current_user
    @current_user ||= User.find_by(id:session[:user_id])
  end
  #判断是否已经登录
  def logged_in?
    !current_user.nil?
  end
  #登出方法
  def log_out
    session.delete(:user_id)
    @current_user=nil
  end
end
