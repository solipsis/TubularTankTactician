class Entity
	
	

	attr_accessor :x, :y, :width, :height

	def initialize(x, y, width, height, img, gameWindow)
		@x = x
		@y = y
		@width = width
		@height = height
		@img = img
		@gameWindow = gameWindow
	end


	def draw
	@img.draw_as_quad(@x, @y, 0xffffffff, 
			@x + @width, @y, 0xffffffff,
			@x, @y + @height, 0xffffffff,
			@x + @width, @y + @height, 0xffffffff, 0 )
	end

	def update
	end

	def intersects?(e2)
		return (@x <= (e2.x + e2.width) &&
				e2.x <= (@x + @width) &&
				@y <= (e2.y + e2.height) &&
				e2.y <= (@y + @height)
		)
	end

end