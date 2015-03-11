class SpawnZone < Entity

	attr_accessor :team

	def initialize(x, y, width, height, img, gameWindow, team)
		super(x, y, width, height, img, gameWindow)
		@team = team
	end

end