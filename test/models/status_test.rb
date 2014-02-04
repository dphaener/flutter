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
end
