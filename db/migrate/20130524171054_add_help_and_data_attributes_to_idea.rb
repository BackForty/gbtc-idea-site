class AddHelpAndDataAttributesToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :help_needed, :text
    add_column :ideas, :data_needed, :text
  end
end
