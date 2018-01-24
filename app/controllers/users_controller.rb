class UsersController < ApplicationController
  #指定在调用edit和update方法之前先调用logged_in_user和correct_user方法
  before_action :logged_in_user,only:[:edit,:update,:index,:destroy,:following,:followers]
  before_action :correct_user,only:[:edit,:update]
  before_action :admin_user,only: :destroy
  #获取所有用户列表页
  def index
    # @users=User.paginate page:params[:page]
    @users=User.where(activated:true).paginate(page:params[:page])
  end
  #获取user注册页面
  def new
    @user=User.new
  end
  #获取展示user信息页面
  def show
  	@user=User.find(params[:id])
    @microposts=@user.microposts.paginate(page:params[:page])
  	# debugger
    redirect_to root_url and return unless @user
  end
  #注册user方法
  def create
    #通过页面表单传入参数新增user
    @user=User.new(user_params)
    #判断@user保存是否成功
    if @user.save
      #将所有注册用户email放入redis的users集合中
      # $redis.sadd(:users,@user.email)
      #将用户注册信息放入redis
      # $redis.hmset("user-#{@user.email}",:name,@user.name,:email,@user.email,:password_digest,@user.password_digest)
      #保存成功时调用调用sessions_helper定义的log_in方法将user的id存入session
      # log_in @user
      #将注册成功消息放入flash供页面展示
      # flash[:success]="Welcome to the Sample App!"
      #页面跳转到user_url并带入@user参数
      # redirect_to @user
      # redirect_to user_url(@user)

      #注册成功后跳转到首页并发送验证邮箱
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info]="Please check your email to activate your account."
      redirect_to root_url
    else
      #当保存失败时重定向到new方法获取user注册页面
      render 'new'
    end
  end
  #用户编辑自己信息
  def edit
  end
  #更新用户信息方法
  def update
    if @user.update_attributes(user_params)
      #处理更新成功的情况
      flash[:success]="Profile updated"
      redirect_to @user
    else
      #更新失败则跳转到编辑方法
      render 'edit'
    end
  end
  #删除用户信息方法
  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted"
    redirect_to users_url
  end
  def following
    @title="Following"
    @user=User.find(params[:id])
    @users=@user.following.paginate(page:params[:page])
    render 'show_follow'
  end
  def followers
    @title="Followers"
    @user=User.find(params[:id])
    @users=@user.followers.paginate(page:params[:page])
    render 'show_follow'
  end
  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
  #前置过滤器
  #确保用户已登录
  # def logged_in_user
  #   unless logged_in?
  #     #将请求地址存入session
  #     store_location
  #     flash[:danger]="Please log in."
  #     redirect_to login_url
  #   end
  # end
  #确保是正确的用户
  def correct_user
    @user=User.find(params[:id])
    redirect_to root_url unless current_user? @user
  end
  #确保当前用户是否为admin
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
