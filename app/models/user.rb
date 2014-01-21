require 'bcrypt'

class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validates :email, :format => EMAIL_REGEX, :uniqueness => true
  validates :screen_name, :uniqueness => true, :length => 1..15, :format => /\A[^@]+\z/
  validates :full_name, :length => { :minimum => 2 }
  validates :password, :length => { :minimum => 8 }, 
    :format => { :with => /\d/, :message => "must have at least one number" }, 
    :exclusion => ["12345678"], 
    :if => :password_validatible?

  attr_accessor :password

  before_save :encrypt_password

  def self.authenticate(email, password)
    return false unless user = self.find_by(:email => email)
    hashed_password = BCrypt::Engine.hash_secret(password, user.password_salt)
    return false unless hashed_password == user.password_hash
    user
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
