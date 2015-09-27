class D3Service < BaseService
  require 'pp'
  include HTTParty
  # for use in HTTParty
  base_uri 'https://us.api.battle.net'
  default_timeout 20
  open_timeout 20
  read_timeout 20

  def initialize
    @options = { query: {locale: 'en_US', apikey: ENV['BNET_KEY']} }
  end

  def run
    talk 'Removing old profile'
    D3Profile.destroy_all
    talk 'Removing old heroes'
    D3Hero.destroy_all
    get_profile
  end

  def get_profile
    talk 'Getting Profile'
    response = self.class.get("/d3/profile/#{ENV['BNET_TAG']}/", @options)
    json = JSON.parse response.body
    json = json.deep_symbolize_keys
    puts '='*60
    puts json
    puts '/'*60
    @d3_profile = {
      last_hero_played_hero_id: json[:lastHeroPlayed],
      kills_monsters: (json[:kills].present? ? json[:kills][:monsters] : 0),
      kills_elites: (json[:kills].present? ? json[:kills][:elites] : 0),
      kills_hardcore_monsters: (json[:kills].present? ? json[:kills][:hardcoreMonsters] : 0),
      paragon_level: json[:paragonLevel],
      time_played_barbarian: json[:timePlayed][:barbarian],
      time_played_crusader: json[:timePlayed][:crusader],
      time_played_demon_hunter: json[:timePlayed][:'demon-hunter'],
      time_played_monk: json[:timePlayed][:monk],
      time_played_witch_doctor: json[:timePlayed][:'witch-doctor'],
      time_played_wizard: json[:timePlayed][:wizard]
    }
    save_profile

    get_and_save_heroes json[:heroes]
  end

  def get_and_save_heroes(heroes)
    heroes.each do |hero|
      get_hero(hero[:id])
    end
  end

  def get_hero(id)
    talk "Getting Hero #{id}"
    response = self.class.get("/d3/profile/#{ENV['BNET_TAG']}/hero/#{id}", @options)
    json = JSON.parse response.body
    hero = json.deep_symbolize_keys
    puts '='*60
    pp hero
    puts '/'*60

    hash = {
      name: hero[:name],
      paragon_level: hero[:paragonLevel],
      hero_id: hero[:id],
      level: hero[:level],
      hardcore: hero[:hardcore],
      gender: hero[:gender],
      class: hero[:class],
      dead: hero[:dead],
      life: hero[:stats][:life],
      damage: hero[:stats][:damage],
      attack_speed: hero[:stats][:attackSpeed],
      armor: hero[:stats][:armor],
      strength: hero[:stats][:strength],
      dexterity: hero[:stats][:dexterity],
      vitality: hero[:stats][:vitality],
      intelligence: hero[:stats][:intelligence],
      physical_resist: hero[:stats][:physicalResist],
      fire_resist: hero[:stats][:fireResist],
      cold_resist: hero[:stats][:coldResist],
      lightning_resist: hero[:stats][:lightningResist],
      poison_resist: hero[:stats][:poisonResist],
      arcane_resist: hero[:stats][:arcaneResist],
      critical_damage: hero[:stats][:critDamage],
      block_chance: hero[:stats][:blockChance],
      block_amount_min: hero[:stats][:blockAmountMin],
      block_amount_max: hero[:stats][:blockAmountMax],
      damage_increase: hero[:stats][:damageIncrease],
      critical_chance: hero[:stats][:critChance],
      damage_reduction: hero[:stats][:damageReduction],
      thorns: hero[:stats][:thorns],
      life_steal: hero[:stats][:lifeSteal],
      life_per_kill: hero[:stats][:lifePerKill],
      gold_find: hero[:stats][:goldFind],
      magic_find: hero[:stats][:magicFind],
      life_on_hit: hero[:stats][:lifeOnHit],
      primary_resource: hero[:stats][:primaryResource],
      secondary_resource: hero[:stats][:secondaryResource],
      elite_kills: hero[:kills][:elites]
    }

    h = D3Hero.new hash
    talk "Saving Hero #{h.name}"
    h.save!

    hero[:skills].each do |type, skills|
      skills.each do |skill|
        new_skill = nil

        if skill[:skill].present?
          skill_hash = {
            type: type.to_s,
            slug: skill[:skill][:slug],
            name: skill[:skill][:name],
            icon: skill[:skill][:icon],
            level: skill[:skill][:level],
            category_slug: skill[:skill][:categorySlug],
            description: skill[:skill][:description]
          }

          talk "Saving skill #{skill_hash[:name]}"
          new_skill = h.skills.create skill_hash
        end

        if new_skill.present? && skill[:rune].present?
          rune_hash = {
            slug: skill[:rune][:slug],
            type: skill[:rune][:type],
            name: skill[:rune][:name],
            level: skill[:rune][:level],
            description: skill[:rune][:description]
          }

          talk "Saving skill #{skill_hash[:name]} rune #{rune_hash[:name]}"
          new_skill.create_rune rune_hash
        end
      end
    end

    # get_items(h, hero[:items])
  end

  def get_items(hero, items_hash)
    items_hash.each do |location, attrs|
      get_item(hero, location, attrs)
    end
  end

  def get_item(hero, location, item_attrs)
    id = item_attrs[:id]
    talk "Getting Item for #{location}: #{id}"
    response = self.class.get("/d3/data/item/#{id}", @options)
    json = JSON.parse response.body
    json = json.deep_symbolize_keys
    puts '='*60
    pp json
    puts '/'*60

    item = D3Item.new({
      name: get_item_name(item_attrs, json[:name]),
      location: location.to_s.underscore,
      item_id: get_item_id(item_attrs, json[:id]),
      icon: get_item_icon(item_attrs, json[:icon]),
      color: get_item_color(item_attrs, json[:displayColor]),
      required_level: json[:requiredLevel],
      level: json[:itemLevel],
      type_name: json[:typeName],
      two_handed: json[:type][:twoHanded],
      armor_min: (json[:armor].present? ? json[:armor][:min] : 0),
      armor_max: (json[:armor].present? ? json[:armor][:max] : 0),
    })

    hero.items << item

    json[:attributes].each do |key, attrs|
      attrs.each do |attr|
        item.item_attributes.create({
          d3_item_id: attr[:id],
          type: key,
          text: attr[:text],
          affix_type: attr[:affixType],
          color: attr[:color]
        })
      end
    end

    return item
  end

  def save_profile
    D3Profile.destroy_all

    profile = D3Profile.new @d3_profile
    profile.save!
  end

  def get_item_color(item_attrs, fallback)
    if item_attrs[:displayColor].present?
      item_attrs[:displayColor]
    else
      fallback
    end
  end

  def get_item_name(item_attrs, fallback)
    if item_attrs[:name].present?
      item_attrs[:name]
    else
      fallback
    end
  end

  def get_item_icon(item_attrs, fallback)
    get_item_prop_or_default(:icon, item_attrs, fallback)
  end

  def get_item_id(item_attrs, fallback)
    get_item_prop_or_default(:id, item_attrs, fallback)
  end

  def get_item_prop_or_default(prop, item_attrs, default)
    if item_attrs[0].present? && item_attrs[0][:craftedBy].present? && item_attrs[0][:craftedBy][:itemProduced].present?
      item_attrs[0][:craftedBy][:itemProduced][prop]
    else
      default
    end
  end
end
