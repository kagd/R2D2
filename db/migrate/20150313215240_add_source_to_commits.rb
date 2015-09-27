class AddSourceToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :source, :string
  end
end
