require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  context "GET #new" do
    context "if not logged in" do
      setup do
        get :new
      end

      should respond_with(200)
      should render_template("new")
    end

    context "if already logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        get :new
      end

      should "redirect to statuses" do
        assert_redirected_to statuses_url
      end
    end
  end

  context "POST #create" do
    context "with valid credentials" do
      setup do
        @user = Fabricate(:user)
        post :create, :email => @user.email, :password => @user.password
      end

      should "redirect to statuses" do
        assert_redirected_to statuses_url
      end

      should "remember who logged in" do
        assert_logged_in_as @user
      end
    end

    context "with invalid credentials" do
      setup do
        post :create, :email => "foo", :password => "bar"
      end

      should render_template("new")
      should "set a flash alert" do
        assert_not_nil flash[:alert]
      end
    end

    context "if already logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        post :create, :email => @user.email, :password => @user.password
      end

      should "redirect to statuses" do
        assert_redirected_to statuses_url
      end
    end
  end

  context "DELETE #destroy" do 
    context "if user is logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        delete :destroy
      end

      should "log out the current user" do
        assert_logged_out
      end

      should "redirect to statuses page" do
        assert_redirected_to statuses_url        
      end
    end  

    context "if user is not logged in" do
      setup do
        delete :destroy
      end

      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end
  end

end
