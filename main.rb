require 'gosu'
require_relative 'fpscounter'
require_relative 'scoreCounter'
require_relative 'entity'
require_relative 'tank'
require_relative 'player'
require_relative 'obstacle'
require_relative 'flag'
require_relative 'spawnZone'

class GameWindow < Gosu::Window
	
	attr_accessor :players, :obstacles, :flags, :scoreCounter, :spawnZones

	def initialize
		super 1280, 800, false
		self.caption = "Tubular Tank Tactician"
		@fpscounter = FPSCounter.new(self)
		@scoreCounter = ScoreCounter.new(self)
		@background = Gosu::Image.new(self, "background.png", false)
		@img = Gosu::Image.new(self, "kappa.jpg", false)
		@obstacle_img = Gosu::Image.new(self, "obstacle.png", false)
		@flag_img = Gosu::Image.new(self, "kappa.jpg", false)
		#@p1 = Tank.new(5, 5, 50, 50, @img, self, 1)


		@players = Array.new()
		@player1_controls = {
			:up => Gosu::Gp0Up,
			:down => Gosu::Gp0Down,
			:left => Gosu::Gp0Left,
			:right => Gosu::Gp0Right,
			:t1 => Gosu::Gp0Button2,
			:t2 => Gosu::Gp0Button3,
			:t3 => Gosu::Gp0Button1,
			:record => Gosu::Gp0Button0,
			:debug => Gosu::Gp0Button4
		}
		img = Gosu::Image.new(self, "tank1_dark.png", false)
		bullet_image = Gosu::Image.new(self, "bullet1.png", false)
		@players.push(Player.new(self, 1, img, bullet_image, @player1_controls ))
		
		@player2_controls = {
			:up => Gosu::Gp1Up,
			:down => Gosu::Gp1Down,
			:left => Gosu::Gp1Left,
			:right => Gosu::Gp1Right,
			:t1 => Gosu::Gp1Button2,
			:t2 => Gosu::Gp1Button3,
			:t3 => Gosu::Gp1Button1,
			:record => Gosu::Gp1Button0,
			:debug => Gosu::Gp1Button4
		}

		img = Gosu::Image.new(self, "tank2.png", false)
		bullet_image = Gosu::Image.new(self, "bullet2.png", false)
		@players.push(Player.new(self, 2, img, bullet_image, @player2_controls ))




		@obstacles = Array.new()
		@obstacles.push(Obstacle.new(500,500, 400, 100, @obstacle_img, self))
		@obstacles.push(Obstacle.new(0,0, 1000, 50, @obstacle_img, self))
		@obstacles.push(Obstacle.new(0,0, 50, 800, @obstacle_img, self))
		@obstacles.push(Obstacle.new(1000,0, 50, 800, @obstacle_img, self))
		@obstacles.push(Obstacle.new(0,700, 1000, 50, @obstacle_img, self))
		
		@flags = Array.new()
		@flags.push(Flag.new(800, 400, 70, 70, @flag_img, self, 2))
		@flags.push(Flag.new(400, 400, 70, 70, @flag_img, self, 1))
		
		@spawnZones = Array.new()
		@spawnZones.push(SpawnZone.new(100,100, 100, 100, bullet_image, self, 1))
		@spawnZones.push(SpawnZone.new(400,100, 100, 100, bullet_image, self, 2))
	end

	def draw
		@background.draw(0,0,0)
		@fpscounter.draw()
		@scoreCounter.draw()

		
		@players.each do |ent|
			ent.draw()
		end
		@obstacles.each do |obs|
			obs.draw()
		end
		@flags.each do |flag|
			flag.draw()
		end

		@spawnZones.each do |zone|
			zone.draw()
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
