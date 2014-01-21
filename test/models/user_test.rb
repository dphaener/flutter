require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should "validate" do
    user = Fabricate.build(:user)
    assert user.valid?  
  end

  should "require an email address" do
    user = Fabricate.build(:user)
    user.email = nil
    assert user.invalid?
  end

  should "require a unique email address" do
    user = Fabricate(:user)
    user2 = Fabricate.build(:user)
    user2.email = user.email
    assert user2.invalid?
  end

  should "require a properly formatted email" do
    user = Fabricate.build(:user)
    addresses = ["foo", "foo@bar", "foo.com"]

    addresses.each do |address|
      user.email = address
      assert user.invalid?, "#{address} should not be valid"
    end
  end

  should "require an email address" do
    user = Fabricate.build(:user)

    user.email = nil
    assert !user.valid?

    user.email = ""
    assert !user.valid?
  end

  should "require a unique email address" do
    Fabricate(:user, :email => "foo@bar.com")
    user = Fabricate.build(:user, :email => "foo@bar.com")
    assert !user.valid?
  end

  should "require a unique screen name" do
    Fabricate(:user, :screen_name => "john")
    user = Fabricate.build(:user, :screen_name => "john")
    assert !user.valid?
  end

  should "require a screen name no more than 15 characters long" do
    user = Fabricate.build(:user, :screen_name => "a" * 16)
    assert !user.valid?
  end

  should "require a full name at least 2 characters long" do
    user = Fabricate.build(:user, :full_name => "a")
    assert !user.valid?
  end

  should "have a password" do
    user = Fabricate.build(:user)
    user.password = "foo"
    assert_equal "foo", user.password
  end

  should "require password to be at least 8 characters" do
    user = Fabricate.build(:user, :password => "aaaaaa1")
    assert user.invalid?
  end

  should "require password to have at least 1 number" do
    user = Fabricate.build(:user, :password => "b" * 8)
    assert user.invalid?
  end

  should "not allow password to be '12345678'" do
    user = Fabricate.build(:user, :password => "12345678")
    assert user.invalid?
  end

  should "not validate password if the password is blank" do
    user = Fabricate(:user)
    user.password = nil
    assert user.valid?
  end

  context "before save" do
    context "if password is set" do
      setup do
        @user = Fabricate.build(:user, :password => "password123")
        @user.save
      end

      should "generate a salt and hash" do
        assert @user.password_salt.present?
        assert @user.password_hash.present?
      end
    end

    context "if password is not set" do
      setup do
        @user = Fabricate(:user)
        @hash = @user.password_hash
        @salt = @user.password_salt

        @user.password = nil
        @user.save
      end

      should "not change the salt and hash" do
        assert_equal @hash, @user.password_hash
        assert_equal @salt, @user.password_salt
      end
    end
  end

  context ".authenticate" do
    setup do
      @user = Fabricate(:user)
    end

    should "return false if user does not exist" do
      assert_equal false, User.authenticate("me@example.com", "foo")
    end

    should "return false if user exists and password is wrong" do
      assert_equal false, User.authenticate(@user.email, "wrongpassword")
    end

    should "return the user if user exists and password is correct" do
      assert_equal @user, User.authenticate(@user.email, @user.password)
    end
  end
end