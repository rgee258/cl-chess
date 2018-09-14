require "board"

class Game

  def initialize
  	@board = nil
  	@player_one = nil
  	@player_two = nil
  end

  def player_turn
  end

  # Will need to loop make move whenever the move is found to be invalid
  # Either add the loop to the play method or the make_move method when you get
  def make_move
  	move_format = /^[a-hA-H][1-8](?!.)/
    position_swaps = {"a": 7, "A": 7, "b": 6, "B": 6, "c": 5, "C": 5, "d": 4, "D": 4,
      "e": 3, "E": 3, "f": 2, "F": 2, "g": 1, "G": 1, "h": 0, "H": 0}
    move_start = "invalid move"
    move_end = "invalid move"
    start = []
    finish = []

    puts "Which piece would you like to move?"

    while move_format.match(move_start).nil? do
      puts "Invalid start position, try again."
      move_start = gets.chomp
    end

  	# add logic for figuring out move and coordinates into board
  end

  def resign
  end

  def play
  end

end