class AddUserReferenceToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :reply_to, :integer, index: true
  end
end
