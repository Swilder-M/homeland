class DeleteTeamFeature < ActiveRecord::Migration[7.1]
  def change
    # 删除用户表中的 location、location_id 和 team_users_count 字段
    remove_column :users, :location, :string
    remove_column :users, :location_id, :integer
    remove_column :users, :team_users_count, :integer

    # 来自 topics 表的 team_id
    remove_column :topics, :team_id, :integer

    # 删除整个 locations 和 team_users 表
    drop_table :locations
    drop_table :team_users
  end
end
