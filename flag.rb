class Flag < Entity

	attr_accessor :team

	def initialize(x, y, width, height, img, gameWindow, team)
		super(x, y, width, height, img, gameWindow)
		@team = team
		@start_x = x
		@start_y = y
	end

	def drop
		#TODO: could glitch if non-moving entity on flag spawn
		@x = @start_x
		@y = @start_y
	end

	def grab
		@x = -50
		@y = -50
	end

	

	def respawn
	end
end