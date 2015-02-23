class Direction
	UP = :up
	DOWN = :down
	LEFT = :left 
	RIGHT = :right
end

class TankState
	SELECTED = :selected 
	RECORDING = :recording
	NOT_SELECTED = :not_selected 

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
		@shot_time = 50
		@time_until_shot = @shot_time
		@state = TankState::SELECTED
	end

	def update
		

		case @state
		when TankState::SELECTED	
			dir = nil
			num_directions_pressed = 0
			if @gameWindow.button_down?(Gosu::Gp0Left) || @gameWindow.button_down?(Gosu::KbLeft) then
				dir = Direction::LEFT
				num_directions_pressed += 1
			end
			if @gameWindow.button_down?(Gosu::Gp0Right) || @gameWindow.button_down?(Gosu::KbRight) then
				dir = Direction::RIGHT
				num_directions_pressed += 1
			end
			if @gameWindow.button_down?(Gosu::Gp0Up) || @gameWindow.button_down?(Gosu::KbUp) then
				dir = Direction::UP	
				num_directions_pressed += 1
			end
			if @gameWindow.button_down?(Gosu::Gp0Down) || @gameWindow.button_down?(Gosu::KbDown) then
				dir = Direction::DOWN
				num_directions_pressed += 1
			end
			if num_directions_pressed == 1
				move(dir)
				if dir != nil
					@prev_direction = dir
				end

			end

			if @gameWindow.button_down?(Gosu::Gp0Button1) || @gameWindow.button_down?(Gosu::KbSpace) then
				@state = TankState::NOT_SELECTED
				@time_until_shot = @shot_time
			end
		when TankState::NOT_SELECTED
			@time_until_shot -= 1
			if @time_until_shot <= 0
				@bullets.push(Bullet.new(@gameWindow, @team, @x, @y, @prev_direction)) #fix this.
				@time_until_shot = @shot_time
			end
			if @gameWindow.button_down?(Gosu::Gp0Button1) || @gameWindow.button_down?(Gosu::KbSpace) then
				@state = TankState::SELECTED
			end
		end

		@bullets.each do |bullet|
			bullet.move
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

	def trans_selected_to_not_selected #todo: ouauuau
	end

	def toggle(bool) 
		if bool == true then
			bool = false
		else
			bool = true
		end
	end


end 

