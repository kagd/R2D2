class DiabloController < ApplicationController
  def index
    @heroes = D3Hero.all.includes(items: :item_attributes).includes(skills: :rune)

    @profile = D3Profile.first
  end
end
