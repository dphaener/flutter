class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validates :email, :format => EMAIL_REGEX, :uniqueness => true
  validates :screen_name, :uniqueness => true, :length => 1..15, :format => /\A[^@]+\z/
  validates :full_name, :length => { :minimum => 2 }
  validates :password, :length => { :minimum => 8 }, 
    :format => /\d/, :exclusion => ["12345678"], 
    :if => :password_validatible?

  attr_accessor :password

  def password_validatible?
    return password.present? || self.new_record?
  end

# This code is replaced by attr_accessor

  # def password=(value)
  #   @password = value
  # end

  # def password
  #   @password
  # end
end
