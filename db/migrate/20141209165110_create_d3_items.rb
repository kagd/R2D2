class CreateD3Items < ActiveRecord::Migration
  def change
    create_table :d3_items do |t|
      t.integer :d3_hero_id
      t.string :name
      t.string :location
      t.string :item_id
      t.string :icon
      t.string :color
      t.integer :required_level
      t.integer :level
      t.string :type_name
      t.boolean :two_handed
      t.integer :armor_min
      t.integer :armor_max

      t.timestamps
    end
  end
end
