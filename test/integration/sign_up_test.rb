require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  test "get sign up form and create user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {username: "jack", email: "test@email.com", password: "123456"} }
      follow_redirect!
    end
    assert_template 'users/show'
    assert_match 'jack', response.body
  end

  test "invalid sign up submission results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params: { user: {username: "", email: "test@email.com", password: "123456"} }
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end
