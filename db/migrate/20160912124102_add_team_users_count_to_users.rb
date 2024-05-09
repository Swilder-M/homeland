class AddTeamUsersCountToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :team_users_count, :integer
  end

  def down
    remove_column :users, :team_users_count
  end
end
