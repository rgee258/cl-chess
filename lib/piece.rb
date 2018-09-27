class Piece

  attr_accessor :type, :color, :move_counter

  def initialize(type, color)
    @type = type
    @color = color
    @move_counter = 0
  end
end