class CreateD3Profiles < ActiveRecord::Migration
  def change
    create_table :d3_profiles do |t|
      t.integer :last_hero_played_hero_id
      t.integer :kills_monsters
      t.integer :kills_elites
      t.integer :kills_hardcore_monsters
      t.integer :paragon_level
      t.float :time_played_barbarian
      t.float :time_played_crusader
      t.float :time_played_demon_hunter
      t.float :time_played_monk
      t.float :time_played_witch_doctor
      t.float :time_played_wizard

      t.timestamps
    end
  end
end
