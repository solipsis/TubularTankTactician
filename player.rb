class Player

	def initialize(gameWindow)
		@gameWindow = gameWindow
		@tanks = Array.new()
		@img = Gosu::Image.new(@gameWindow, "kappa.jpg", false)
		@player1_controls = {
			:up => Gosu::Gp0Up,
			:down => Gosu::Gp0Down,
			:left => Gosu::Gp0Left,
			:right => Gosu::Gp0Right,
			:t1 => Gosu::Gp0Button0,
			:t2 => Gosu::Gp0Button1,
			:t3 => Gosu::Gp0Button2
		}
		@tanks.push(Tank.new(5, 5, 50, 50, @img, @gameWindow, 1, @player1_controls, :t1))
		@tanks.push(Tank.new(100, 100, 50, 50, @img, @gameWindow, 1, @player1_controls, :t2))
		@tanks.push(Tank.new(200, 200, 50, 50, @img, @gameWindow, 1, @player1_controls, :t3))

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