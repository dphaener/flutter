require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  context "GET #index" do
    setup do
      get :index
    end

    should render_template("index")
    should "assign to statuses" do
      assert_not_nil assigns(:statuses)
    end
  end

  context "GET #new" do
    context "if user is not logged in" do
      setup do
        get :new
      end

      should "redirect to new session page" do
        assert_redirected_to new_session_url
      end
    end
    
    context "if user is logged in" do
      setup do
        @user = Fabricate(:user)
        login_as(@user)
        get :new
      end

      should respond_with(200)
      should render_template("new")
      should "assign to statuses" do
        assert_not_nil assigns(:status)
      end
    end
    
  end

  context "POST #create" do
    context "if user is not logged in" do
      setup do
        @status = Fabricate.attributes_for(:status)
        post :create, status: @status
      end

      should "redirect to login page" do
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      context "with valid input" do
        setup do
          @user = Fabricate(:user)
          login_as(@user)
          @status = Fabricate.attributes_for(:status)
        end

        should "create a new status and associate it with the user" do
          assert_difference("Status.count") do
            post :create, status: @status
          end
          assert_redirected_to statuses_url
          @status = Status.last
          assert_equal @user.id, @status.user.id
          assert_not_nil flash[:notice]
        end
      end

      context "with invalid input" do
        setup do
          @user = Fabricate(:user)
          login_as(@user)
          @status = Fabricate.attributes_for(:status, text: "a"*141)
        end

        should "re-render the form with error messages" do
          assert_no_difference("Status.count") do
            post :create, status: @status
          end
          assert_template "new"
        end
      end
    end
    
  end
end