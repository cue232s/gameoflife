require './game_of_life'
class Game
	attr_accessor :neighborhood 
	ROW = 15
	COL = 15
  
  # use this method to select which residents are living
  def randomstatus
  	[true, false].sample
  end

  def initialize 
  	@neighborhood = Neighborhood.new
  	(0..ROW-1).each do |row|
  		(0..COL-1).each do |col|
  			@residence = Resident.new(@neighborhood, row, col)
  			@residence.living = randomstatus
  		end
  	end
  end

  def print_generation
  	(0..ROW-1).each do |row|
  		(0..COL-1).each do |col|
  			resident = find_resident(row, col)
  			print resident.living ? "O" : "X" 
  		end
  		puts
  	end
  end

  def show_neigborhood
  	neighborhood.residents
  end

  def find_resident(x, y)
  	residents =  neighborhood.residents.find_all{|i| i.x == x}
  	resident = residents.find_all {|i| i.y == y }.first
  end
end

g = Game.new
5.times {puts g.print_generation
g.neighborhood.generation
}
