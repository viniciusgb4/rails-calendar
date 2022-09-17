class AddColorToReminder < ActiveRecord::Migration[7.0]
  def change
    add_column :reminders, :color, :string
  end
end
