class Status < ActiveRecord::Base
  belongs_to :user
  validates :text, :length => { :maximum => 140, :minimum => 2 }
end
