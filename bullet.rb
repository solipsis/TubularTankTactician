class Bullet

	def initialize(window, team, x, y) 
		@speed = 10
		@gameWindow = window
		@team = team
		@x = x
		@y = y
		@img = Gosu::Image.new(window, "kappa.jpg", false)
	end

	def move(dir)
		case dir 
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
		@x %= 1280
		@y %= 800
	end

	def draw
		@img.draw_rot(@x, @y, 1, 0)
	end 
end