require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  context "GET #index" do
    setup do
      get :index
    end

    should respond_with(200)
    should render_template("index")
    should "assign to statuses" do
      assert_not_nil assigns(:statuses)
    end
  end
end