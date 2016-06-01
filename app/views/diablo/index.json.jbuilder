json.heroes do
  json.array! @heroes do |hero|
    json.id hero['id']
    json.name hero['name']
    json.gender (hero['gender'] == 0 ? 'male' : 'female')
    json.class hero['class']
    json.dead hero['dead']
    json.seasonal hero['seasonal']
    json.hardcore hero['hardcore']
    json.seasonCreated hero['seasonCreated']
    json.weaponIconUrl "http://media.blizzard.com/d3/icons/items/large/#{hero['items']['mainHand']['icon']}.png"
  end
end

json.profile do
  json.last_hero_played_hero_id @profile['last_hero_played_hero_id']
  json.kills_monsters @profile['kills_monsters']
  json.kills_elites @profile['kills_elites']
  json.kills_hardcore_monsters @profile['kills_hardcore_monsters']
  json.paragon_level @profile['paragon_level']
  json.time_played_barbarian @profile['time_played_barbarian']
  json.time_played_crusader @profile['time_played_crusader']
  json.time_played_demon_hunter @profile['time_played_demon_hunter']
  json.time_played_monk @profile['time_played_monk']
  json.time_played_witch_doctor @profile['time_played_witch_doctor']
  json.time_played_wizard @profile['time_played_wizard']
  json.last_played_at "#{time_ago_in_words(@profile['last_played_at'])} ago"
end
