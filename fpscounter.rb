class FPSCounter

	attr_accessor :show_fps 
	attr_reader :FPSCounter

	def initialize(window) 
		@font = Gosu::Font.new(window, Gosu::default_font_name, 20) 
		@frames_counter = 0
		@milliseconds_before = Gosu::milliseconds
		@show_fps = true
		@fps = 0
	end

	def update 
		@frames_counter += 1
		if Gosu::milliseconds - @milliseconds_before >= 1000
			@fps = @frames_counter.to_f / ((Gosu::milliseconds - @milliseconds_before) / 1000)
			@frames_counter = 0
			@milliseconds_before = Gosu::milliseconds
		end
	end

	def draw
		@font.draw("FPS: " + @fps.to_s, 0, 0, 20) if @show_fps
	end
end