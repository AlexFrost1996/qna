class RemoveColumnCorrect < ActiveRecord::Migration[6.1]
  def up
    remove_column :answers, :correct
  end

  def down
    add_column :answers, :correct, :boolean
  end
end
