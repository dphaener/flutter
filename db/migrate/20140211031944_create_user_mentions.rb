class CreateUserMentions < ActiveRecord::Migration
  def change
    create_table :user_mentions do |t|
      t.references :user, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
