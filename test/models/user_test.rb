require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
end
