class DiabloController < ApiController
  def index
    @heroes = Dir["#{Rails.root.join('data', 'd3', 'heroes', '**')}"].map do |hero_file_path|
      YAML.load(File.read(hero_file_path))
    end

    @profile = YAML.load(File.read( Rails.root.join('data', 'd3', 'profile.yml') ))
  end
end
