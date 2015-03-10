class Player

	attr_accessor :tanks
	attr_accessor :input_map
	attr_accessor :bullet_image

	def initialize(gameWindow)
		@gameWindow = gameWindow
		@tanks = Array.new()
		
		@img = Gosu::Image.new(@gameWindow, "tank1_dark.png", false)
		@bullet_image = Gosu::Image.new(@gameWindow, "bullet1.png", false)

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
		

		@input_map = @player1_controls
		@tanks.push(Tank.new(100, 100, 50.0, 50.0, @img, @gameWindow, 1, self, :t1))
		@tanks.push(Tank.new(200, 200, 50.0, 50.0, @img, @gameWindow, 1, self, :t2))
		@tanks.push(Tank.new(300, 300, 50.0, 50.0, @img, @gameWindow, 1, self, :t3))

		#@p1 = Tank.new(5, 5, 50, 50, @img, self, 1)
		
	end

	def update
		@tanks.each do |tank|
			tank.update()
		end
		#check if button down
		#use an input map
		#check button_down event that fires once not the button_down?
		#remove state change logic from TankStates

		#update all tanks
		#check collisions for all tanks
	end

	def draw
		@tanks.each do |tank|
			tank.draw()
		end
	end

	def button_down(id)
		case id
		when @input_map[:t1]
			toggle_state(:t1)	
		when @input_map[:t2]
			toggle_state(:t2)
		when @input_map[:t3]
			toggle_state(:t3)
		when @input_map[:debug]
			@tanks[2].die()
		end

	end

	def toggle_state(id) 
		@tanks.each do |tank|
			if tank.state.get_state_name() == :selected
				if tank.input_queue.size > 0
					tank.state = PlaybackState.new(@gameWindow, tank)
				else
					tank.state = NotSelectedState.new(@gameWindow, tank)
				end 
			elsif tank.id == id
				tank.state = SelectedState.new(@gameWindow, tank)
			end
		end
	end

	


end


controls = Hash.new()


#player1_controls = Hash.new()


player2_controls = {
	"up" => Gosu::Gp1Up,
	"down" => Gosu::Gp1Down,
	"left" => Gosu::Gp1Left,
	"right" => Gosu::Gp1Right	
}

player3_controls = {
	"up" => Gosu::Gp2Up,
	"down" => Gosu::Gp2Down,
	"left" => Gosu::Gp2Left,
	"right" => Gosu::Gp2Right
}

player4_controls = {
	"up" => Gosu::Gp3Up,
	"down" => Gosu::Gp3Down,
	"left" => Gosu::Gp3Left,
	"right" => Gosu::Gp3Right
}