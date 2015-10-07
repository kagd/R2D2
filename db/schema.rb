# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151007051927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commit_languages", force: :cascade do |t|
    t.string   "extention"
    t.integer  "commit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commits", force: :cascade do |t|
    t.string   "repo_full_name"
    t.string   "message"
    t.datetime "date"
    t.integer  "additions"
    t.integer  "deletions"
    t.integer  "number_of_files"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sha"
    t.string   "source"
  end

  create_table "d3_heros", force: :cascade do |t|
    t.integer  "paragon_level"
    t.string   "name"
    t.integer  "hero_id"
    t.integer  "level"
    t.boolean  "hardcore"
    t.integer  "gender"
    t.string   "class"
    t.boolean  "dead"
    t.integer  "life"
    t.integer  "damage"
    t.float    "attack_speed"
    t.integer  "armor"
    t.integer  "strength"
    t.integer  "dexterity"
    t.integer  "vitality"
    t.integer  "intelligence"
    t.integer  "physical_resist"
    t.integer  "fire_resist"
    t.integer  "cold_resist"
    t.integer  "lightning_resist"
    t.integer  "poison_resist"
    t.integer  "arcane_resist"
    t.float    "critical_damage"
    t.float    "block_chance"
    t.integer  "block_amount_min"
    t.integer  "block_amount_max"
    t.integer  "damage_increase"
    t.integer  "critical_chance"
    t.integer  "damage_reduction"
    t.integer  "thorns"
    t.integer  "life_steal"
    t.integer  "life_per_kill"
    t.float    "gold_find"
    t.float    "magic_find"
    t.integer  "life_on_hit"
    t.integer  "primary_resource"
    t.integer  "secondary_resource"
    t.integer  "elite_kills"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d3_item_attributes", force: :cascade do |t|
    t.integer  "d3_item_id"
    t.string   "type"
    t.string   "text"
    t.string   "affix_type"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d3_items", force: :cascade do |t|
    t.integer  "d3_hero_id"
    t.string   "name"
    t.string   "location"
    t.string   "item_id"
    t.string   "icon"
    t.string   "color"
    t.integer  "required_level"
    t.integer  "level"
    t.string   "type_name"
    t.boolean  "two_handed"
    t.integer  "armor_min"
    t.integer  "armor_max"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d3_profiles", force: :cascade do |t|
    t.integer  "last_hero_played_hero_id"
    t.integer  "kills_monsters"
    t.integer  "kills_elites"
    t.integer  "kills_hardcore_monsters"
    t.integer  "paragon_level"
    t.float    "time_played_barbarian"
    t.float    "time_played_crusader"
    t.float    "time_played_demon_hunter"
    t.float    "time_played_monk"
    t.float    "time_played_witch_doctor"
    t.float    "time_played_wizard"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_played_at"
  end

  create_table "d3_runes", force: :cascade do |t|
    t.integer  "d3_skill_id"
    t.string   "slug"
    t.string   "type"
    t.string   "name"
    t.integer  "level"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d3_skills", force: :cascade do |t|
    t.integer  "d3_hero_id"
    t.string   "type"
    t.string   "slug"
    t.string   "name"
    t.string   "icon"
    t.integer  "level"
    t.string   "category_slug"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
