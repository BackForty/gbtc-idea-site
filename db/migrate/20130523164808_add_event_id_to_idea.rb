class AddEventIdToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :event_id, :integer, null: false
  end
end
