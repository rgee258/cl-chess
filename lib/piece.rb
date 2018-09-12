class Piece

	attr_accessor :type, :color, :moved

	def initialize(type, color)
		@type = type
		@color = color
		@moved = false
	end

end