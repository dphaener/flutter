class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text :text

      t.timestamps
    end
  end
end
