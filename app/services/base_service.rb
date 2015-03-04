class BaseService

  private #-----------------------------------

  def talk(str, color=:light_blue)
    puts '/'*60
    puts str.colorize(color)
  end
end
