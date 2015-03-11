class ScoreCounter

	def initialize(window)
		@font = Gosu::Font.new(window, Gosu::default_font_name, 40)
		@team1_score = 0
		@team2_score = 0
	end


	def score(team)
		if (team == 1)
			@team1_score += 1
		end
		if (team == 2)
			@team2_score += 1
		end
	end

	def draw
		@font.draw("Red: " + @team1_score.to_s + "                                       Blue: " + @team2_score.to_s, 200, 50, 25)
	end
end