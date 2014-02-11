class Status < ActiveRecord::Base
  belongs_to :user
  has_many :user_mentions
  
  validates :text, :length => { :maximum => 140, :minimum => 2 }
  default_scope { order("created_at DESC") }

  before_save :check_for_reply
  after_save :check_mentions
  
  def reply_user
    return nil unless reply_to
    @user = User.find(reply_to)
  end

  def mentioned_users
    return unless user_mentions = self.user_mentions
    users = []
    user_mentions.each do |mention|
      users << User.find(mention.user_id).screen_name
    end  
    return users
  end
  
private

  def check_for_reply
    username = text.scan(/\A@(\S+)/)
    return if username.empty?
    return unless user = User.find_by(screen_name: username[0])
    self.reply_to = user.id
  end
  
  def check_mentions  
    users = text.scan(/@(\w+)/).uniq
    return if users.empty?
    users.each do |user|
      if mentioned = User.find_by(screen_name: user)
        UserMention.create(status_id: self.id, user_id: mentioned.id)
      end
    end
  end
end
