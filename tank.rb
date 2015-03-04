

class TankState 
	def initialize(gameWindow, tank)
		@gameWindow = gameWindow
		@tank = tank
	end

	def update

	end
end

class SelectedState < TankState
	def update
		dir = nil
		num_directions_pressed = 0
		if @gameWindow.button_down?(@tank.input_map[:left]) || @gameWindow.button_down?(Gosu::KbLeft) then
			dir = :left 
			num_directions_pressed += 1
		end
		if @gameWindow.button_down?(@tank.input_map[:right]) || @gameWindow.button_down?(Gosu::KbRight) then
			dir = :right
			num_directions_pressed += 1
		end
		if @gameWindow.button_down?(@tank.input_map[:up]) || @gameWindow.button_down?(Gosu::KbUp) then
			dir = :up	
			num_directions_pressed += 1
		end
		if @gameWindow.button_down?(@tank.input_map[:down]) || @gameWindow.button_down?(Gosu::KbDown) then
			dir = :down
			num_directions_pressed += 1
		end
		if num_directions_pressed == 1
			@tank.move(dir)
		end

		#TODO: state transition logic should be kept higher up
		if @gameWindow.button_down?(@tank.input_map[@tank.id]) || @gameWindow.button_down?(Gosu::KbSpace) then
			@tank.state = NotSelectedState.new(@gameWindow, @tank)			
		end	
	end
end

class NotSelectedState < TankState
	def initialize(gameWindow, tank)
		super(gameWindow, tank)
		@tank.remaining_time = @tank.shot_time
	end

	def update
		@tank.remaining_time -= 1
		if @tank.remaining_time <= 0
			@tank.shoot(:up)
		end

		#TODO: state transition logic should be kept higher up
		if @gameWindow.button_down?(@tank.input_map[@tank.id]) || @gameWindow.button_down?(Gosu::KbSpace) then
			@tank.state = SelectedState.new(@gameWindow, @tank)
		end
	end
end


class Tank < Entity
	
	require_relative 'bullet'
	
	#TODO: make most of these read only
	attr_accessor :dir
	attr_accessor :shot_time, :remaining_time
	attr_accessor :state
	attr_accessor :input_map
	attr_accessor :id

	
	#TODO: find better place for input map
	def initialize(x, y, width, height, img, gameWindow, team, input_map, id)
		super(x, y, width, height, img, gameWindow)
		@id = id
		@input_map = input_map
		@team = team
		@speed = 5
		@health = 1
		@bullets = Array.new()
		@shot_time = 50
		@remaining_time = @shot_time
		@state = SelectedState.new(@gameWindow, self)
	end

	def update
		@state.update()
		@bullets.each do |bullet|
			bullet.update()
		end
	end

	def draw
		super()
		#@img.draw_rot(@x, @y, 1, 0)
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

	
	def toggle(bool) 
		if bool == true then
			bool = false
		else
			bool = true
		end
	end

	def shoot(dir)
		@bullets.push(Bullet.new@x, @y, 20, 20, @img, @gameWindow, 3, 1, dir) #fix this.
		@remaining_time = @shot_time
	end


end 

