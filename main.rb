require 'gosu'
require_relative 'fpscounter'
require_relative 'tank'

class GameWindow < Gosu::Window
	
	def initialize
		super 1280, 800, false
		self.caption = "Tubular Tank Tactician"
		@fpscounter = FPSCounter.new(self)
		@p1 = Tank.new(self, 0)
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
