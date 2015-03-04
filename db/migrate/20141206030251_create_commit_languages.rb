class CreateCommitLanguages < ActiveRecord::Migration
  def change
    create_table :commit_languages do |t|
      t.string :extention
      t.integer :commit_id

      t.timestamps
    end
  end
end
