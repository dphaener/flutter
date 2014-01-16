require 'bcrypt'

class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validates :email, :format => EMAIL_REGEX, :uniqueness => true
  validates :screen_name, :uniqueness => true, :length => 1..15, :format => /\A[^@]+\z/
  validates :full_name, :length => { :minimum => 2 }
  validates :password, :length => { :minimum => 8 }, 
    :format => /\d/, :exclusion => ["12345678"], 
    :if => :password_validatible?

  attr_accessor :password

  before_save :encrypt_password

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
