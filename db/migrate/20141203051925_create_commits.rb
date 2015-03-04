class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string    :repo_full_name
      t.string    :message
      t.datetime  :date
      t.integer   :additions
      t.integer   :deletions
      t.integer   :number_of_files

      t.timestamps
    end
  end
end
