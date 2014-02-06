class Status < ActiveRecord::Base
  belongs_to :user
  validates :text, :length => { :maximum => 140, :minimum => 2 }
  default_scope { order("created_at DESC") }

  before_save :check_for_reply
  
  def reply_user
    
  end

private

  def check_for_reply
    
  end
end
