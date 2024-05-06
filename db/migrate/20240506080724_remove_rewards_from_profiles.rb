class RemoveRewardsFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :rewards, :jsonb
  end
end
