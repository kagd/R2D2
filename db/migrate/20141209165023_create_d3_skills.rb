class CreateD3Skills < ActiveRecord::Migration
  def change
    create_table :d3_skills do |t|
      t.integer :d3_hero_id
      t.string :type
      t.string :slug
      t.string :name
      t.string :icon
      t.integer :level
      t.string :category_slug
      t.text :description

      t.timestamps
    end
  end
end
