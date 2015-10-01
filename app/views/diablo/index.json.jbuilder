json.heroes do
  json.array! @heroes do |hero|
    json.name hero.id
    json.name hero.name
    json.paragon_level hero.paragon_level
    json.hero_id hero.hero_id
    json.level hero.level
    json.hardcore hero.hardcore
    json.gender (hero.gender == 0 ? 'male' : 'female')
    json.class hero.read_attribute(:class)
    json.dead hero.dead
    json.life hero.life
    json.damage hero.damage
    json.attack_speed hero.attack_speed
    json.armor hero.armor
    json.strength hero.strength
    json.dexterity hero.dexterity
    json.vitality hero.vitality
    json.intelligence hero.intelligence
    json.physical_resist hero.physical_resist
    json.fire_resist hero.fire_resist
    json.cold_resist hero.cold_resist
    json.lightning_resist hero.lightning_resist
    json.poison_resist hero.poison_resist
    json.arcane_resist hero.arcane_resist
    json.critical_damage hero.critical_damage
    json.block_chance hero.block_chance
    json.block_amount_min hero.block_amount_min
    json.damage_increase hero.damage_increase
    json.critical_chance hero.critical_chance
    json.damage_reduction hero.damage_reduction
    json.thorns hero.thorns
    json.life_steal hero.life_steal
    json.life_on_hit hero.life_on_hit
    json.life_per_kill hero.life_per_kill
    json.gold_find hero.gold_find
    json.magic_find hero.magic_find
    json.primary_resource hero.primary_resource
    json.secondary_resource hero.secondary_resource
    json.elite_kills hero.elite_kills

    json.items do
      hero.items.each do |item|
        json.set! item.location do
          json.id item.id
          json.name item.name
          json.location item.location
          json.icon_url "http://media.blizzard.com/d3/icons/items/large/#{item.icon}.png"
          json.color item.color
          json.required_level item.required_level
          json.level item.level
          json.type_name item.type_name
          json.two_handed item.two_handed
          json.armor_min item.armor_min
          json.armor_max item.armor_max

          json.item_attributes do
            json.array! item.item_attributes do |ia|
              json.id ia.id
              json.type ia.type
              json.text ia.text
              json.affix_type ia.affix_type
              json.color ia.color
            end
          end
        end
      end
    end

    json.skills do
      json.array! hero.skills do |skill|
        json.id skill.id
        json.name skill.name
        json.type skill.type
        json.slug skill.slug
        json.icon_url "http://media.blizzard.com/d3/icons/skills/42/#{skill.icon}.png"
        json.level skill.level
        json.category_slug skill.category_slug
        json.description skill.description

        if skill.rune.present?
          json.rune do
            json.id skill.rune.id
            json.name skill.rune.name
            json.slug skill.rune.slug
            json.type skill.rune.type
            json.level skill.rune.level
            json.description skill.rune.description
          end
        end
      end
    end
  end
end

json.profile do
  json.last_hero_played_hero_id @profile.last_hero_played_hero_id
  json.kills_monsters @profile.kills_monsters
  json.kills_elites @profile.kills_elites
  json.kills_hardcore_monsters @profile.kills_hardcore_monsters
  json.paragon_level @profile.paragon_level
  json.time_played_barbarian @profile.time_played_barbarian
  json.time_played_crusader @profile.time_played_crusader
  json.time_played_demon_hunter @profile.time_played_demon_hunter
  json.time_played_monk @profile.time_played_monk
  json.time_played_witch_doctor @profile.time_played_witch_doctor
  json.time_played_wizard @profile.time_played_wizard
  json.last_played_at "#{time_ago_in_words(@profile.last_played_at)} ago"
end
