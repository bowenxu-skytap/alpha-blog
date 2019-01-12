require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "yaru", email: "yaru@email.com", password: "123456")
  end

  test "get new article form and create article" do
    sign_in_as(@user, "123456")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: {title: "this is a test article", description: "this is article description", category_ids: "1"} }
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_match 'this is a test article', response.body
  end

  test "invalid article submission results in failure" do
    sign_in_as(@user, "123456")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: {title: "th", description: "tssssss", category_ids: "1"} }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
