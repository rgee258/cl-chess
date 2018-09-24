require "board"

class Game

  def initialize
  	@game_board = nil
  	@player_one = nil
  	@player_two = nil
    @turn_count = 1
    @current_player = nil
    # Increase turn_count every time the game loop starts, but it would need to start at 0
    # OR increase it at the very end of the loop, after every single method is run
  end

  def assign_players
    puts "Okay, let's assign the players of this game."
    puts "Who will be player one? You will be assigned white on the board."
    @player_one = Person.new(gets.chomp, "white")
    puts "Now, who will be player two? You will be assigned black on the board."
    @player_two = Person.new(gets.chomp, "black")
    @current_player = @player_one
  end

  def new_board
    @game_board = Board.new
    @game_board.create_board
    @game_board.add_pieces
  end

  def player_turn
    if (@current_player == @player_one)
      puts "It is your turn #{@player_one.name} (Player 1), what would you like to do?"
    else
      puts "It is your turn #{@player_two.name} (Player 2), what would you like to do?"
    end

    # Add print statements for turn options
    # Chain turn options from this method for the turn
  end

  # Will need to loop make move whenever the move is found to be invalid
  # Either add the loop to the play method or the make_move method when you get
  def make_move
  	move_format = /^[a-hA-H][1-8](?!.)/
    move_start = "invalid move"
    move_end = "invalid move"
    start = []
    finish = []

    puts "Which piece would you like to move?"

    move_start = gets.chomp.downcase

    while move_format.match(move_start).nil? do
      puts "Invalid start position, try again."
      move_start = gets.chomp.downcase
    end

    puts "Where would you like to move your piece?"

    move_end = gets.chomp.downcase

    while move_format.match(move_start).nil? do
      puts "Invalid end position, try again."
      move_end = gets.chomp.downcase
    end

    move_start.split("").each {|chr| start.push(convert_to_index(chr))}
    move_finish.split("").each {|chr| finish.push(convert_to_index(chr))}

  	# add logic for figuring out move and coordinates into board
    # will likely need to make this into an if statement based on string return
    @game_board.move_piece(start, finish, @current_player.color)
  end

  def convert_to_index(chr)
    position_swaps = {"a" => 7, "b" => 6, "c" => 5, "d" => 4, "e" => 3, "f" => 2, 
      "g" => 1, "h" => 0}
    coord = -5

    if (position_swaps[chr].nil?)
      coord = chr.to_i - 1
    else
      coord = position_swaps[chr]
    end
    coord
  end

  def resign
    if (@current_player == @player_one)
      # Call game end with P2 as the winner
    else
      # Call game end with P1 as the winner
    end
  end

  def save_game
  end

  def load_game
  end

  def change_turn
    @turn_count += 1
    if (@current_player == @player_one)
      @current_player = @player_two
    elsif (@current_player == @player_two)
      @current_player = @player_one
    end
    "Beginning new turn"
  end

  def play
  end

end