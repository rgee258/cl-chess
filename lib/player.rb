class Player

	attr_accessor :name, :color, :check

	def initialize(name, color)
		@name = name
		@color = color
		@check = false
	end
end