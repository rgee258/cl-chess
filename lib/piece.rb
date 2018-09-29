class Piece

  attr_accessor :type, :color, :last_moved, :times_moved

  def initialize(type, color)
    @type = type
    @color = color
    @last_moved = 0
    @times_moved = 0
  end
end