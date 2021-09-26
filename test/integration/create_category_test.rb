require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
    sign_in_as(@admin_user)
  end

  test "get new category form and create category" do
    get "/categories/new"
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: "Sports" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Sports", response.body
  end

  test "get new category form and reject invalid category submission" do
    get "/categories/new"
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: " " } }
    end
    # looking for word errors which shows up in case of invalid category in error partial
    assert_match "errors", response.body
    # looking for div inside error partial
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test "get new category form and reject same category submission" do
    category = Category.new(name: "Sports")
    category.save
    get "/categories/new"
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: "Sports" } }
    end
    assert_match "Name has already been taken", response.body
  end
end
