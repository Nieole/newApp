require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user=users(:michael)
    @micropost=microposts(:orange)
  end
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title',full_title(@user.name)
    assert_select 'h1',text:@user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s,response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page:1).each do |micropost|
      assert_match micropost.content,response.body
    end
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path,params:{micropost:{content:"Lorem ipsum"}}
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
end
