require 'rspec'
require 'yaml'

class Resident
	attr_accessor :x, :y, :neighborhood, :living

	def initialize(neighborhood, x=0, y=0)
		@neighborhood = neighborhood
		@x = x
		@y = y
		neighborhood.residents << self
		@living = true
	end
	# checks to see what neighbors border a person
	def neighbors 
		@neighbors = []
		neighborhood.residents.each do |resident|
			if resident.living
			# neighbor to the north?
				if self.x == resident.x && self.y == resident.y - 1
					@neighbors << resident
				end
				# neighbor to the south?
				if self.x == resident.x && self.y == resident.y + 1
					@neighbors << resident
				end
				#neighbor to the west?
				if self.x == resident.x + 1 && self.y == resident.y
					@neighbors << resident
				end
				# neighbor to the east
				if self.x == resident.x - 1 && self.y == resident.y
					@neighbors << resident
				end
				# neighbor to the northeast
				if self.x == resident.x - 1 && self.y == resident.y - 1
					@neighbors << resident
				end
				# neighbor to the northwest
				if self.x == resident.x + 1 && self.y == resident.y - 1
					@neighbors << resident
				end
				# neighbor to the southeast	
				if self.x == resident.x - 1 && self.y == resident.y + 1
					@neighbors << resident
				end
				# neighbor to the southwest
				if self.x == resident.x + 1 && self.y == resident.y + 1
					@neighbors << resident
				end
			end
		end		
		@neighbors
	end

	def spawn_at(x, y)
		Resident.new(neighborhood, x, y)
	end
end

 
class Neighborhood
	attr_accessor :residents, :living

	def initialize
		@residents = []
		@living = []
	end

	def generation
		@residents.each do |resident|
			#mark every resident with less that 2 neighbors as not living
			if resident.neighbors.count < 2
				resident.living = false				
			end
			# mark every living resident with more that 3 neighbors as not living
			if resident.living && resident.neighbors.count > 3
				resident.living = false
			end
			#mark every dead resident with exactly 3 neighbors as living
			if !resident.living && resident.neighbors.count == 3
				resident.living = true
			end
		end


		# kill off every resident that has been marked
		# @residents.reverse.each do |resident|
		# 	@residents.delete(resident) unless resident.living
		# end
	end

end

describe "game of life" do
	let(:neighborhood) {Neighborhood.new}
	context "resident utility methods" do
		subject {Resident.new(neighborhood)}
		it "spawn relative to" do
			resident = subject.spawn_at(3,5)
			resident.is_a?(Resident).should be_true
			resident.x.should == 3
			resident.y.should == 5
			resident.neighborhood.should == subject.neighborhood
		end

		it "detects a neighbor to the north" do
			resident = subject.spawn_at(0, 1)
			subject.neighbors.count.should == 1
		end	

		it "detects a neighbor to the south" do
			resident = subject.spawn_at(0, -1)
			subject.neighbors.count.should == 1
		end

		it "detects a neighbor to the east" do
			resident = subject.spawn_at(1, 0)
			subject.neighbors.count.should == 1
		end
		it "detects a neighbor to the west" do 
			resident = subject.spawn_at(-1, 0)
			subject.neighbors.count.should == 1
		end

		it "detects a neighbor to the northeast" do
			resident = subject.spawn_at(1, 1)
			subject.neighbors.count.should == 1
		end

		it "detects a neighbor to the northwest" do 
			resident = subject.spawn_at(-1, 1)
			subject.neighbors.count.should == 1
		end

		it "detects a neighbor to the southeast" do
			resident = subject.spawn_at(1, -1)
			subject.neighbors.count.should == 1
		end

		it "detects a neighbor to the southwest" do
			resident = subject.spawn_at(-1,-1)
			subject.neighbors.count.should == 1
		end

	end

	it "Rule #1: Any live resident with fewer than two live neighbors dies, as if by loneliness." do 
		resident = Resident.new(neighborhood)
		new_resident = resident.spawn_at(2,0)
		neighborhood.generation
		resident.living.should be_false
		neighborhood.residents.should be_empty #only the 'new_resident' resident should be in the world
	end

	describe "Rule #2: Any live resident with two or three live neighbors lives on to the next generation." do
		context "has 2 neighbors" do
			it "should live on" do
				resident = Resident.new(neighborhood)
				neighbor1 = resident.spawn_at(0,1)
				neighbor2 = resident.spawn_at(1,-1)
				neighborhood.generation
				resident.living.should be_true
			end
		end

		context "has 3 neighbors" do
			it "should live on" do
				resident = Resident.new(neighborhood)
				neighbor1 = resident.spawn_at(0,1)
				neighbor2 = resident.spawn_at(1,-1)
				neighbor3 = resident.spawn_at(1,-1)
				neighborhood.generation
				resident.living.should be_true
			end
		end
	end	

	it "Rule #3: Any live cell with more than three live neighbors dies, as if by overcrowding." do
		resident = Resident.new(neighborhood)
		neighbor1 = resident.spawn_at(0,1)
		neighbor2 = resident.spawn_at(1,-1)
		neighbor3 = resident.spawn_at(1,-1)
		neighbor4 = resident.spawn_at(1, 0)
		neighborhood.generation
		resident.living.should be_false		
	end

	it "Rule #4: Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction." do
		resident = Resident.new(neighborhood)
		resident.living = false
		neighbor1 = resident.spawn_at(0, 1)
		neighbor2 = resident.spawn_at(1, 1)
		neighbor3 = resident.spawn_at(-1, 0)
		neighborhood.generation 
		resident.living.should be_true
	end

end
