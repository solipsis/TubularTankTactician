class Direction
	UP = :up
	DOWN = :down
	LEFT = :left 
	RIGHT = :right
end

class TankState
	SELECTED = :selected 
	RECORDING = :recording

end


class Tank
	require_relative 'bullet'
	# @inputQueue
	# @health
	attr_accessor :isSelected

	#include Directions

	def initialize(window, team)
		@gameWindow = window
		@team = team
		@speed = 5
		@health = 1
	#	@isSelected? = false
		@x = 50
		@y = 50
		@width = 50
		@height = 50
		@img = Gosu::Image.new(window, "kappa.jpg", false)
		@prev_direction = nil
		@bullets = Array.new()
	end

	def update
		
		dir = nil
		num_directions_pressed = 0
		if @gameWindow.button_down? Gosu::Gp0Left then
			#move(Direction::LEFT)
			dir = Direction::LEFT
			num_directions_pressed += 1
		end
		if @gameWindow.button_down? Gosu::Gp0Right then
			#move(Direction::RIGHT)
			dir = Direction::RIGHT
			num_directions_pressed += 1
		end
		if @gameWindow.button_down? Gosu::Gp0Up then
			#move(Direction::UP)
			dir = Direction::UP
			num_directions_pressed += 1
		end
		if @gameWindow.button_down? Gosu::Gp0Down then
			#move(Direction::DOWN)
			dir = Direction::DOWN
			num_directions_pressed += 1
		end
		if num_directions_pressed == 1
			move(dir)
		end

		if @gameWindow.button_down? Gosu::Gp0Button1 then
			if isSelected then
				isSelected = false
			else
				isSelected = true
			end
		end
		if isSelected then
			@bullets.push(Bullet.new(@gameWindow, @img, @x, @y))
		end

	end

	def draw
		@img.draw_rot(@x, @y, 1, 0)
		@bullets.each do |x|
			x.draw()
		end
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
end 

