class D3Service < BaseService
  require 'pp'
  include HTTParty
  attr_accessor :d3_profile, :heroes
  # for use in HTTParty
  base_uri 'https://us.api.battle.net'
  default_timeout 20
  open_timeout 20
  read_timeout 20

  def initialize
    @options = { query: {locale: 'en_US', apikey: ENV['BNET_KEY']} }
  end

  def run
    begin
      get_profile
    rescue Exception => e
      talk 'Error getting profile', :red
      puts e.message
      run
    end

    get_and_save_heroes
  end

  def get_profile
    talk 'Getting Profile'
    response = self.class.get("/d3/profile/#{ENV['BNET_TAG']}/", @options)
    json = JSON.parse response.body
    json = json.deep_symbolize_keys
    @heroes = json[:heroes]

    d3_profile = {
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
      time_played_wizard: json[:timePlayed][:wizard],
      last_played_at: DateTime.strptime(json[:lastUpdated].to_s,'%s')
    }

    profile_file_path = Rails.root.join('data', 'd3', 'profile.yml')

    File.open(profile_file_path, "w") do |f|
      f.write JSON.parse(d3_profile.to_json).to_yaml
    end
  end

  def get_and_save_heroes
    heroes.each do |hero|
      get_hero(hero[:id])
    end
  end

  def get_hero(id)
    begin
      talk "Getting Hero #{id}"
      response = self.class.get("/d3/profile/#{ENV['BNET_TAG']}/hero/#{id}", @options)
      json = JSON.parse response.body

      if json['code'].present?
        talk "Error getting hero #{id}", :red
        puts json
        get_hero(id)
      else
        talk "Saving Hero #{json['name']}"
        hero_file_path = Rails.root.join('data', 'd3', 'heroes', "#{id}.yml")
        File.open(hero_file_path, "w") do |f|
          f.write json.to_yaml
        end
      end
    rescue => e
      talk "Error getting hero #{id}", :red
      puts e.message
      puts e.backtrace.join("\n")
      get_hero(id)
    end
  end

  # hero[:skills].each do |type, skills|
  #   skills.each do |skill|
  #     new_skill = nil
  #
  #     if skill[:skill].present?
  #       skill_hash = {
  #         type: type.to_s,
  #         slug: skill[:skill][:slug],
  #         name: skill[:skill][:name],
  #         icon: skill[:skill][:icon],
  #         level: skill[:skill][:level],
  #         category_slug: skill[:skill][:categorySlug],
  #         description: skill[:skill][:description]
  #       }
  #
  #       talk "Saving skill #{skill_hash[:name]}"
  #       new_skill = h.skills.create skill_hash
  #     end
  #
  #     if new_skill.present? && skill[:rune].present?
  #       rune_hash = {
  #         slug: skill[:rune][:slug],
  #         type: skill[:rune][:type],
  #         name: skill[:rune][:name],
  #         level: skill[:rune][:level],
  #         description: skill[:rune][:description]
  #       }
  #
  #       talk "Saving skill #{skill_hash[:name]} rune #{rune_hash[:name]}"
  #       new_skill.create_rune rune_hash
  #     end
  #   end
  # end

  # def get_items(hero, items_hash)
  #   items_hash.each do |location, attrs|
  #     get_item(hero, location, attrs)
  #   end
  # end
  #
  # def get_item(hero, location, item_attrs)
  #   id = item_attrs[:id]
  #   talk "Getting Item for #{location}: #{id}"
  #   response = self.class.get("/d3/data/item/#{id}", @options)
  #   json = JSON.parse response.body
  #   json = json.deep_symbolize_keys
  #   puts '='*60
  #   pp json
  #   puts '/'*60
  #
  #   item = D3Item.new({
  #     name: get_item_name(item_attrs, json[:name]),
  #     location: location.to_s.underscore,
  #     item_id: get_item_id(item_attrs, json[:id]),
  #     icon: get_item_icon(item_attrs, json[:icon]),
  #     color: get_item_color(item_attrs, json[:displayColor]),
  #     required_level: json[:requiredLevel],
  #     level: json[:itemLevel],
  #     type_name: json[:typeName],
  #     two_handed: json[:type][:twoHanded],
  #     armor_min: (json[:armor].present? ? json[:armor][:min] : 0),
  #     armor_max: (json[:armor].present? ? json[:armor][:max] : 0),
  #   })
  #
  #   hero.items << item
  #
  #   json[:attributes].each do |key, attrs|
  #     attrs.each do |attr|
  #       item.item_attributes.create({
  #         d3_item_id: attr[:id],
  #         type: key,
  #         text: attr[:text],
  #         affix_type: attr[:affixType],
  #         color: attr[:color]
  #       })
  #     end
  #   end
  #
  #   return item
  # end
  #
  # def get_item_color(item_attrs, fallback)
  #   if item_attrs[:displayColor].present?
  #     item_attrs[:displayColor]
  #   else
  #     fallback
  #   end
  # end
  #
  # def get_item_name(item_attrs, fallback)
  #   if item_attrs[:name].present?
  #     item_attrs[:name]
  #   else
  #     fallback
  #   end
  # end
  #
  # def get_item_icon(item_attrs, fallback)
  #   get_item_prop_or_default(:icon, item_attrs, fallback)
  # end
  #
  # def get_item_id(item_attrs, fallback)
  #   get_item_prop_or_default(:id, item_attrs, fallback)
  # end
  #
  # def get_item_prop_or_default(prop, item_attrs, default)
  #   if item_attrs[0].present? && item_attrs[0][:craftedBy].present? && item_attrs[0][:craftedBy][:itemProduced].present?
  #     item_attrs[0][:craftedBy][:itemProduced][prop]
  #   else
  #     default
  #   end
  # end
end
