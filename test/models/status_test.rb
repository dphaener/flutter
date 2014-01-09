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
end
