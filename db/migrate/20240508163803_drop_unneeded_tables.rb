class DropUnneededTables < ActiveRecord::Migration[7.1]
  def up
    drop_table :comments
    drop_table :page_versions
    drop_table :pages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
