class Relationship < ActiveRecord::Base
  belongs_to :follower_user, :class_name => "User", :foreign_key => "follower_id"
  belongs_to :followed_user, :class_name => "User", :foreign_key => "followed_id"

  validates :follower_id, uniqueness: { scope: [:followed_id] }
end
