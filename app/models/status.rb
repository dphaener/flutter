class Status < ActiveRecord::Base
  validates :text, :length => { :maximum => 140, :minimum => 2 }
end
