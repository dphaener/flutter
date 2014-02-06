require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  context "POST #create" do
    setup do
      @user = Fabricate(:user)
    end
     

    context "if user is not logged in" do
      setup do
        post :create, screen_name: @user.screen_name
      end

      should "redirect to login" do
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      setup do
        @logged_in_user = Fabricate(:user)
        login_as(@logged_in_user)
      end

      context "if screen name is found" do
        setup do
          post :create, screen_name: @user.screen_name
        end

        should "create a relationship" do
          assert @logged_in_user.following?(@user)
        end

        should "redirect to the followed users profile page" do
          assert_redirected_to profile_url(@user)
        end
      end

      context "if screen name is not found" do
        should "raise a routing error if screen name is not found" do
          assert_raises(ActionController::RoutingError) do
            post :create, screen_name: "idontexist"
          end
        end
      end
    end
  end
end
