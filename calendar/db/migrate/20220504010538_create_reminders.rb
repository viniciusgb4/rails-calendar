class CreateReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :reminders do |t|
      t.string :title
      t.string :description
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.timestamps
    end
  end
end
