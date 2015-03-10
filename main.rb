require 'gosu'
require_relative 'fpscounter'
require_relative 'entity'
require_relative 'tank'
require_relative 'player'
require_relative 'obstacle'
require_relative 'flag'

class GameWindow < Gosu::Window
	
	attr_accessor :players, :obstacles, :flags

	def initialize
		super 1280, 800, false
		self.caption = "Tubular Tank Tactician"
		@fpscounter = FPSCounter.new(self)
		@background = Gosu::Image.new(self, "background.png", false)
		@img = Gosu::Image.new(self, "kappa.jpg", false)
		@obstacle_img = Gosu::Image.new(self, "obstacle.png", false)
		@flag_img = Gosu::Image.new(self, "kappa.jpg", false)
		#@p1 = Tank.new(5, 5, 50, 50, @img, self, 1)
		@players = Array.new()
		@players.push(Player.new(self))
		@obstacles = Array.new()
		@obstacles.push(Obstacle.new(500,500, 400, 100, @obstacle_img, self))
		@obstacles.push(Obstacle.new(0,0, 1000, 50, @obstacle_img, self))
		@obstacles.push(Obstacle.new(0,0, 50, 800, @obstacle_img, self))
		@obstacles.push(Obstacle.new(1000,0, 50, 800, @obstacle_img, self))
		@obstacles.push(Obstacle.new(0,700, 1000, 50, @obstacle_img, self))
		@flags = Array.new()
		@flags.push(Flag.new(800, 400, 70, 70, @flag_img, self, 2))
		@flags.push(Flag.new(400, 400, 70, 70, @flag_img, self, 1))
		
	end

	def draw
		@background.draw(0,0,0)
		@fpscounter.draw()

		
		@players.each do |ent|
			ent.draw()
		end
		@obstacles.each do |obs|
			obs.draw()
		end
		@flags.each do |flag|
			flag.draw()
		end

	end

	def update
		@fpscounter.update()
		@players.each do |ent|
			ent.update()
		end
	end

	def button_down(id)
		@players.each do |player|
			player.button_down(id)
		end
	end

end

GameWindow.new.show
