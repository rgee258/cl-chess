class Player

  attr_accessor :name, :color, :check, :castling_used

  def initialize(name, color)
    @name = name
    @color = color
    @check = false
    @castling_used = false
  end
end