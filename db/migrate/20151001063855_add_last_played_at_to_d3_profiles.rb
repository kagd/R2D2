class AddLastPlayedAtToD3Profiles < ActiveRecord::Migration
  def change
    add_column :d3_profiles, :last_played_at, :date
  end
end
