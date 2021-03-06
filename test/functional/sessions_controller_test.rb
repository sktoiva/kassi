require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def test_login_and_logout
    post :create, { :username => "kassi_testperson1", :password => "testi"}
    assert_response :found
    assert_not_nil session[:cookie]

    delete :destroy
    assert_response :found
    assert_nil session[:cookie]
  end
  
  def test_login_form
    get :new
    assert_response :success
    assert_template "new"
  end
end
