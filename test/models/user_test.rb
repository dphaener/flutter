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
end
