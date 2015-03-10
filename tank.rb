

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
		@tank.input_queue = Array.new()
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
					#puts @tank.input_queue
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
			@tank.shoot(@tank.dir)
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
	attr_accessor :team

	
	#TODO: find better place for input map
	def initialize(x, y, width, height, img, gameWindow, team, player, id)
		super(x, y, width, height, img, gameWindow)

		#clean up all these useless instance variables scrub
		@death_time = 300
		@time_till_respawn = @death_time
		@dead = false
		@init_x = x
		@init_y = y
		@id = id
		@player = player
		@input_map = player.input_map
		@team = team
		@speed = 2
		@health = 1
		@bullets = Array.new()
		@shot_time = 50
		@remaining_time = @shot_time
		@state = NotSelectedState.new(@gameWindow, self)
		@input_queue = Array.new()
		@flag = nil
		@font = Gosu::Font.new(gameWindow, Gosu::default_font_name, 35)
		@dir = :right		
		@is_selected
	end

	def update
		@state.update()


		#make this a state dumbass
		if (@dead)
			@time_till_respawn -= 1
			if @time_till_respawn < 0
				respawn()
			end
		end


		#TODO: Optomize the shit out of this trash
		@bullets.each do |bullet|
			bullet.update()
			@gameWindow.obstacles.each do |obs|
				if bullet.intersects?(obs)
					@bullets.delete(bullet)
				end
			end
			@gameWindow.players.each do |player|
				player.tanks.each do |tank|
					if bullet.intersects?(tank) && tank != self
						@bullets.delete(bullet)

						if tank.team != @team
							tank.die()
						end
					end
				end
			end


		end
	end

	def draw
		#super()
		#@image.draw_rot(@x, @y, 1, u0)
		angle = 0
		case @dir
		when :up
			angle = 270
		when :down
			angle = 90
		when :left
			angle = 180
		when :right
			angle = 0
		end
		
		color = Gosu::Color.new(0xFFFFFFFF)
		#puts color.hue.to_s
		if (@state.get_state_name() == :selected)
			color.saturation = 0.8
			color.value = 0.8
		end

		drawKey()
		x_scale = @width / @img.width
		y_scale = @height / @img.height
		@img.draw_rot(@x + (@width/2.0), @y + (@height/2.0), 1, angle, 0.5, 0.5, x_scale, y_scale, color)
		@bullets.each do |x|
			x.draw()
		end
	end

	def move(dir)
		@dir = dir
		old_x = @x
		old_y = @y
		speed = @speed
		if (@has_flag)
			speed = speed * (2.0/3.0)
		end

		case dir 
		when :up
			@y -= speed
		when :down
			@y += speed
		when :right
			@x += speed
		when :left
			@x -= speed
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

		@gameWindow.flags.each do |flag|
			if (self.intersects?(flag))
				if flag.team != @team
					grabFlag(flag)
				elsif (flag.team == @team && @has_flag)
					@gameWindow.scoreCounter.score(@team)
					@flag.drop
					@flag = nil
					@has_flag = false
				end
			end
		end

		# screen wrap
		#@x %= 1280
		#@y %= 800
	end


	#holy shit are u serious
	def can_spawn?
		
	end


	def grabFlag(flag)
		flag.grab()
		@has_flag = true
		@flag = flag
	end


	def toggle(bool) 
		if bool == true then
			bool = false
		else
			bool = true
		end
	end


	#hardcoded piece of shit
	def shoot(dir)
		x_origin = @x + (@width / 2.0) - (10)
		y_origin = @y + (@height / 2.0) - (10)
		@bullets.push(Bullet.new(x_origin, y_origin, 20, 20, @player.bullet_image, @gameWindow, 3, 3, dir)) #fix this.
		@remaining_time = @shot_time
	end

	def reset_input_queue
		@input_queue = Array.new()
	end

	#dafuq is this shit
	def die
		#seriously wtf
		@dead = true
		if (@has_flag)
			@has_flag = false
			@flag.drop()
			@flag = nil
		end
		
		#@flag = nil
		@x = -500
		@y = -500
		@time_till_respawn = @death_time
		#start death countdown timer
	end

	def respawn

		dead_x = @x
		dead_y = @y

		@x = @init_x
		@y = @init_y

		@player.tanks.each do |tank|
			if(self.intersects?(tank) && tank != self)
				@x = dead_x
				@y = dead_y
				return
			end
		end

		@gameWindow.obstacles.each do |obs|
			if(self.intersects?(obs))
				@x = dead_x
				@y = dead_y
				return
			end
		end
		@dead = false
	end

	def drawKey
		case @id
		when :t1
			@font.draw("X", @x + 15, @y + 7, 20)
		when :t2
			@font.draw("Y", @x + 15, @y + 7, 20)
		when :t3
			@font.draw("B", @x + 15, @y + 7, 20)
		end
	end



end 

