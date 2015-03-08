

class TankState 
	def initialize(gameWindow, tank)
		@gameWindow = gameWindow
		@tank = tank
	end

	def update

	end

	def get_state_name
		return :default
	end
end


class PlaybackState < TankState
	def initialize(gameWindow, tank)
		super(gameWindow, tank)
		@input_queue = tank.input_queue
	end

	def update

		if (@input_queue.size > 0)
			old_x = @tank.x
			old_y = @tank.y
			@tank.move(@input_queue.first)
			if (old_x == @tank.x && old_y == @tank.y)
				@input_queue.delete_at(0)
			end

		else
			@tank.state = NotSelectedState.new(@gameWindow, @tank)
		end
	end

	def get_state_name
		return :playback
	end
end

class SelectedState < TankState

	def initialize(gameWindow, tank)
		super(gameWindow, tank)
		#@tank.reset_input_queue()
		@prev_dir = nil
	end

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
			if @gameWindow.button_down?(@tank.input_map[:record])
				if (@prev_dir != dir)
					@tank.input_queue.push(dir)
					#puts @tank.input_queue.to_s
					@prev_dir = dir
				end
			else
				@tank.move(dir)
			end
			
		end

		#TODO: state transition logic should be kept higher up
		if @gameWindow.button_down?(@tank.input_map[@tank.id]) || @gameWindow.button_down?(Gosu::KbSpace) then
			#@tank.state = NotSelectedState.new(@gameWindow, @tank)			
		end	
	end

	def get_state_name
		return :selected
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
			#@tank.state = SelectedState.new(@gameWindow, @tank)
		end
	end

	def get_state_name
		return :not_selected
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
	attr_accessor :input_queue

	
	#TODO: find better place for input map
	def initialize(x, y, width, height, img, gameWindow, team, player, id)
		super(x, y, width, height, img, gameWindow)
		@id = id
		@player = player
		@input_map = player.input_map
		@team = team
		@speed = 5
		@health = 1
		@bullets = Array.new()
		@shot_time = 50
		@remaining_time = @shot_time
		@state = SelectedState.new(@gameWindow, self)
		@input_queue = Array.new()		
	end

	def update
		@state.update()

		#TODO: Optomize the shit out of this trash
		@bullets.each do |bullet|
			bullet.update()
			@gameWindow.obstacles.each do |obs|
				if bullet.intersects?(obs)
					@bullets.delete(bullet)
				end
			end
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
		old_x = @x
		old_y = @y
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

		@player.tanks.each do |tank|
			if(self.intersects?(tank) && tank != self)
				@x = old_x
				@y = old_y
				#puts "intersect"
				break
			end
		end

		@gameWindow.obstacles.each do |obs|
			if(self.intersects?(obs))
				@x = old_x
				@y = old_y
				break
			end
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

	def reset_input_queue
		@input_queue = Array.new()
	end

end 

