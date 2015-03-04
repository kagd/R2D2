class CreateD3Heros < ActiveRecord::Migration
  def change
    create_table :d3_heros do |t|
      t.integer :paragon_level
      t.string :name
      t.integer :hero_id
      t.integer :level
      t.boolean :hardcore
      t.integer :gender
      t.string :class
      t.boolean :dead
      t.integer :life
      t.integer :damage
      t.float :attack_speed
      t.integer :armor
      t.integer :strength
      t.integer :dexterity
      t.integer :vitality
      t.integer :intelligence
      t.integer :physical_resist
      t.integer :fire_resist
      t.integer :cold_resist
      t.integer :lightning_resist
      t.integer :poison_resist
      t.integer :arcane_resist
      t.float :critical_damage
      t.float :block_chance
      t.integer :block_amount_min
      t.integer :block_amount_max
      t.integer :damage_increase
      t.integer :critical_chance
      t.integer :damage_reduction
      t.integer :thorns
      t.integer :life_steal
      t.integer :life_per_kill
      t.float :gold_find
      t.float :magic_find
      t.integer :life_on_hit
      t.integer :primary_resource
      t.integer :secondary_resource
      t.integer :elite_kills

      t.timestamps
    end
  end
end
