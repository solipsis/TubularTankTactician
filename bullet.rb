class Bullet < Entity

	def initialize(x, y, width, height, img, gameWindow, team, speed, dir) 
		super(x, y, width, height, img, gameWindow)
		@team = team
		@speed = speed
		@dir = dir
	end

	def move
		case @dir 
		when :up
			@y -= @speed
		when :down
			@y += @speed
		when :right
			@x += @speed
		when :left
			@x -= @speed
		end

		# screen wrap
		#@x %= 1280
		#@y %= 800
	end

	def draw
		super()
	end 

	def update
		move()
	end
end