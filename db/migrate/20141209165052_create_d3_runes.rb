class CreateD3Runes < ActiveRecord::Migration
  def change
    create_table :d3_runes do |t|
      t.integer :d3_skill_id
      t.string :slug
      t.string :type
      t.string :name
      t.integer :level
      t.text :description

      t.timestamps
    end
  end
end
