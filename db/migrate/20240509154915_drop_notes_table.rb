class DropNotesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :notes if table_exists? :notes
  end
end
