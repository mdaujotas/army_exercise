
class Civilization
  attr_reader :name, :initial_pikemen, :initial_archers, :initial_knights
  
  def initialize(name, pikemen:, archers:, knights:)
    @name = name
    @initial_pikemen = pikemen
    @initial_archers = archers
    @initial_knights = knights
  end
  
  CHINESE = new("Chinese", pikemen: 2,  archers: 25, knights: 2)
  ENGLISH = new("English", pikemen: 10, archers: 10, knights: 10)
  BYZANTINE = new("Byzantine", pikemen: 5,  archers: 8,  knights: 15)
end