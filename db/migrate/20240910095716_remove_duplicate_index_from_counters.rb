class RemoveDuplicateIndexFromCounters < ActiveRecord::Migration[7.1]
  def change
    remove_index :counters, name: "index_counters_on_countable"
  end
end
