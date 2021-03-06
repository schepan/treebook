require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should be redirected from new when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:joe)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:joe)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create status for the current user when logged in" do
    sign_in users(:joe)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:jack).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:joe).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should be redirected from edit when not logged in" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should edit status when logged in" do
    sign_in users(:joe)
    get :edit, id: @status
    assert_response :success
  end

  test "should not be able to edit status for another user" do 
    sign_in users(:joe)
    get :edit, id: statuses(:three)
    assert_response :redirect
    assert_redirected_to feed_path
  end

  test "should not be able to delete a status for another user" do 
    sign_in users(:joe)
    delete :edit, id: statuses(:three)
    assert_response :redirect
    assert_redirected_to feed_path
  end

  test "should be redirected from update status when not logged in" do
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when logged in" do
    sign_in users(:joe)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status for the current user when logged in" do
    sign_in users(:joe)
    put :update, id: @status, status: { content: @status.content, user_id: users(:jack).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:joe).id
  end

  test "should not update status if nothing has changed" do
    sign_in users(:joe)
    put :update, id: @status
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:joe).id
  end

  test "should be redirected from destroy status when not logged in" do
    delete :destroy, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should destroy status when logged in" do
    sign_in users(:joe)
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
