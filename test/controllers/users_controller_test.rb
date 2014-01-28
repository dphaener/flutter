require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "GET #new" do
    setup do
      get :new
    end

    should respond_with(200)
    should render_template("new")
  end

  context "POST #create" do
    context "with valid input" do
      setup do
        @user_params = Fabricate.attributes_for(:user)
      end

      should "create a new user, login, and redirect with a flash" do
        assert_difference("User.count") do
          post :create, :user => @user_params
        end

        assert_redirected_to(statuses_url)
        assert_not_nil(flash[:notice])
        assert_logged_in_as(User.last)
      end
    end

    context "with invalid input" do
      setup do
        post :create, :user => { :email => "foo" }
      end

      should render_template("new")
    end
  end

  context "GET #edit" do
    context "if user is logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        get :edit
      end

     should render_template "edit"
    end

    context "if user is not logged in" do
      setup do
        get :edit
      end
      should "redirect to login page" do 
        assert_redirected_to new_session_url
      end
    end
  end

  context "PUT #update" do
    context "if user is not logged in" do
      setup do
        put :update
      end

      should "redirect to login page" do
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      context "and input is valid" do
        setup do
          @user = Fabricate(:user)
          @new_info = Fabricate.attributes_for(:user, screen_name: "Scooby Doo")
          login_as(@user)
          put :update, user: @new_info
        end

        should "redirect to edit user settings page" do
          assert_redirected_to edit_user_url
        end

        should "flash a success notice" do
          assert_not_nil(flash[:notice])
        end

        should "update the record" do
          @user.reload
          assert_equal "Scooby Doo", @user.screen_name
        end
      end

      context "and input is invalid" do
        setup do
          @user = Fabricate(:user)
          @new_info = Fabricate.attributes_for(:user, email: "foo")
          login_as(@user)
          put :update, user: @new_info
        end

        should render_template "edit"
      end
    end
  end
end
