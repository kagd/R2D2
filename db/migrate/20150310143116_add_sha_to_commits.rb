class AddShaToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :sha, :string
  end
end
