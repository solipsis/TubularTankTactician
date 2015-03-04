require 'gosu'
require_relative 'fpscounter'
require_relative 'entity'
require_relative 'tank'
require_relative 'player'

class GameWindow < Gosu::Window
	
	def initialize
		super 1280, 800, false
		self.caption = "Tubular Tank Tactician"
		@fpscounter = FPSCounter.new(self)
		@img = Gosu::Image.new(self, "kappa.jpg", false)
		#@p1 = Tank.new(5, 5, 50, 50, @img, self, 1)
		@p1 = Player.new(self)

	end

	def draw
		@fpscounter.draw()
		@p1.draw
	end

	def update
		@fpscounter.update()
		@p1.update()
	end

end

GameWindow.new.show
