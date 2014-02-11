require 'bcrypt'

class User < ActiveRecord::Base
  has_many :statuses
  has_many :follower_relationships, class_name: "Relationship", :foreign_key => "follower_id"
  has_many :followed_relationships, class_name: "Relationship", :foreign_key => "followed_id"
  has_many :followed_users, through: :follower_relationships
  has_many :follower_users, through: :followed_relationships
  
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validates :email, :format => EMAIL_REGEX, :uniqueness => true
  validates :screen_name, :uniqueness => true, :length => 1..15, :format => /\A\w+\z/
  validates :full_name, :length => { :minimum => 2 }
  validates :password, :length => { :minimum => 8 }, 
    :format => { :with => /\d/, :message => "must have at least one number" }, 
    :exclusion => ["12345678"], 
    :if => :password_validatible?

  attr_accessor :password

  before_save :encrypt_password
  
  has_many :user_mentions

  def self.authenticate(email, password)
    return false unless user = self.find_by(:email => email)
    hashed_password = BCrypt::Engine.hash_secret(password, user.password_salt)
    return false unless hashed_password == user.password_hash
    user
  end

  def follow(user)
    follower_relationships.create(followed_id: user.id)
  end

  def following?(user)
    follower_relationships.find_by(followed_id: user.id).present?
  end

  def follower_user_count
    @follower_user_count ||= follower_users.count
  end

  def followed_user_count
    @followed_user_count ||= followed_users.count
  end

  def to_param
    screen_name  
  end

  def follower_ratio
    return nil if followed_user_count == 0
    follower_user_count.to_f / followed_user_count
  end

private

  def password_validatible?
    password.present? || new_record?
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
