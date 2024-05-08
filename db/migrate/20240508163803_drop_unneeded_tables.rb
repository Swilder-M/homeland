class DropUnneededTables < ActiveRecord::Migration[7.1]
  def up
    drop_table :comments if table_exists? :comments
    drop_table :page_versions if table_exists? :page_versions
    drop_table :pages if table_exists? :pages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
