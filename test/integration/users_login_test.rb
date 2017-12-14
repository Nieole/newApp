require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user=users(:michael)#通过users.yml获取配置好的信息
  end
  # test "the truth" do
  #   assert true
  # end
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path,params:{session:{email:"",password:""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  test "login with invalid information2" do
    get login_path
    post login_path,params:{session:{email:@user.email,password:'password'}}
    assert_redirected_to @user#检查重定向地址是否正确
    follow_redirect!#访问重定向地址
    assert_template 'users/show'
    assert_select "a[href=?]",login_path,count:0
    assert_select "a[href=?]",logout_path
    assert_select "a[href=?]",user_path(@user)
  end
  test "Valid signup information" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path,params:{user:{name:"Example User",email:"user@example.com",password:"password",password_confirmation:"password"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  test "login with valid information followed by logout" do
    get login_path
    post login_path,params:{session:{email:@user.email,password:'password'}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]",login_path,count:0
    assert_select "a[href=?]",logout_path
    assert_select "a[href=?]",user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]",login_path
    assert_select "a[href=?]",logout_path,count:0
    assert_select "a[href=?]",user_path(@user),count:0
  end
end
