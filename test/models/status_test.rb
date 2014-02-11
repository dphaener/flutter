require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  should "not allow text longer than 140 characters" do
    status = Fabricate.build(:status)
    status.text = "a" * 141
    assert !status.valid?
  end

  should "require text to be at least 2 characters long" do
    status = Fabricate.build(:status)
    status.text = "a"
    assert !status.valid?
  end

  should "load statuses in reverse chronological order" do
    status1 = Fabricate(:status, created_at: 1.day.ago)
    status2 = Fabricate(:status)
    assert_equal [status2, status1], Status.all.to_a
  end

  context "#check_for_reply" do
    setup do
      @user = Fabricate(:user)
    end
    
    context "if status is not a reply" do
      setup do
        @status = Fabricate(:status, user_id: @user.id)  
      end
      
      should "not create a reply_to id" do
        assert_equal nil, @status.reply_to
      end
    end
    
    context "if status is a reply" do
      context "and the user being replied to does not exist" do
        setup do
          @status = Fabricate(:status, user_id: @user.id, text: "@noexist you are great")
        end
        
        should "not create a reply_to id" do
          assert_equal nil, @status.reply_to
        end
      end
      
      context "and the user being replied to exists" do
        setup do
          @status = Fabricate(:status, user_id: @user.id, text: "@#{@user.screen_name} you are great")
        end
        
        should "create a reply_to id with the users id" do
          assert_equal @user.id, @status.reply_to
        end
      end
    end
  end
  
  context "#reply_user" do
    setup do
      @user = Fabricate(:user)
    end
    
    context "if the status is a reply" do
      setup do
        @status = Fabricate(:status, user_id: @user.id, text: "@#{@user.screen_name} you are great")
      end
      
      should "return the user object" do
        assert_equal @user, @status.reply_user
      end
    end
    
    context "if the status is not a reply" do
      setup do
        @status = Fabricate(:status, user_id: @user.id)
      end
      
      should "return nil" do
        assert_equal nil, @status.reply_user
      end
    end
  end
  
  context "#mentions" do
    setup do
      @user = Fabricate(:user)
      @user2 = Fabricate(:user)
      @user3 = Fabricate(:user)
    end
    
    context "if there are no mentions in the status" do
      setup do
        @status = Fabricate(:status, user_id: @user)
      end
      should "not create any records in the user mentions table" do
        assert_equal [], @status.mentioned_users
      end
    end
    
    context "if there are mentions in the status" do
      setup do
        @status = Fabricate(:status, user_id: @user, 
                             text: "@#{@user.screen_name}, @#{@user2.screen_name}, 
                             and @#{@user3.screen_name} rock!")
      end
      should "create a record for every mention in the mentions table" do
        assert_equal [@user.screen_name, @user2.screen_name, @user3.screen_name], @status.mentioned_users
      end
    end
  end
end
