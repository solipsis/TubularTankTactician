class Entity
	
	@x
	@y
	@width
	@height
	@img
	@gameWindow

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

end