require "yaml"
require_relative "board"
require_relative "player"

class Game

  def initialize
    @game_board = nil
    @player_one = nil
    @player_two = nil
    @turn_count = 1
    @current_player = nil
  end

  def program_start
    start_format = /^[1-2](?!.)/
    puts "Welcome to Command Line Chess."
    puts "Would you like to start a new game or load a previously saved game? Choose numerically from:"
    puts "- 1) New"
    puts "- 2) Load"
    start_choice = gets.chomp

    while start_format.match(start_choice).nil? do
      puts "Invalid starting option choice, try again."
      start_choice = gets.chomp
    end

    if (start_choice == "1")
      new_game
    elsif (start_choice == "2")
      load_game
    end
  end

  def instructions
    puts "Let's play a game of chess."
    puts "As a player, you'll take turns back and forth, and the board will be displayed every turn."
    puts "The pieces are denoted as follows:"
    puts "- King (K)"
    puts "- Queen (Q)"
    puts "- Bishop (B)"
    puts "- Knight (N)"
    puts "- Rook (R)"
    puts "- Pawn (P)"
    puts "- Colors are denoted using black and white, and appear as b or w next to each piece such as Kw."
    puts "The move en passant will be done using the pawn you're performing it with."
    puts "As for castling the starting piece will be the king into its expected ending spot, the rook will move accordingly."
    puts "Choose your options from Move, Save, or Resign every turn."
    puts "When prompted for piece locations, you'll use the standard format for the positions, such as a4.\n"
  end

  def assign_players
    puts "Okay, let's assign the players of this game."
    puts "Who will be player one? You will be assigned white on the board."
    @player_one = Player.new(gets.chomp, "white")
    puts "Now, who will be player two? You will be assigned black on the board."
    @player_two = Player.new(gets.chomp, "black")
    @current_player = @player_one
    puts "#{@player_one.name} you are Player 1. Your color is white."
    puts "#{@player_two.name} you are Player 2. Your color is black."
    puts "That should be about everything, you're up first #{@player_one.name} so let's play!\n\n"
  end

  def new_board
    @game_board = Board.new
    @game_board.create_board
    @game_board.add_pieces
  end

  def player_turn
    puts @game_board.display_board
    turn_format = /^[1-3](?!.)/

    if (@current_player == @player_one)
      puts "It is your turn #{@player_one.name} (Player 1), what would you like to do? Select your number choice."
    else
      puts "It is your turn #{@player_two.name} (Player 2), what would you like to do? Select your number choice."
    end

    puts "- 1) Move"
    puts "- 2) Save"
    puts "- 3) Resign"

    turn_choice = gets.chomp.downcase

    while turn_format.match(turn_choice).nil? do
      puts "Invalid turn choice, try again."
      turn_choice = gets.chomp
    end

    if turn_choice == "1"
      loop do
        unless (make_move.include?("Invalid"))
          break
        end
      end
    elsif turn_choice == "2"
      save_game
    elsif turn_choice == "3"  
      resign
    end

  end

  def make_move
    move_format = /^[a-hA-H][1-8](?!.)/
    move_start = "invalid move"
    move_finish = "invalid move"
    start = []
    finish = []

    puts "Which piece would you like to move?"

    move_start = gets.chomp.downcase

    while move_format.match(move_start).nil? do
      puts "Invalid start position, try again."
      move_start = gets.chomp.downcase
    end

    puts "Where would you like to move your piece?"

    move_finish = gets.chomp.downcase

    while move_format.match(move_start).nil? do
      puts "Invalid end position, try again."
      move_finish = gets.chomp.downcase
    end

    # The order of the conversion will be in reverse compared to a chess board format so use unshift
    move_start.split("").each {|chr| start.unshift(convert_to_index(chr))}
    move_finish.split("").each {|chr| finish.unshift(convert_to_index(chr))}

    # Receive the string from the move performed and act accordingly
    move_results = @game_board.move_piece(start, finish, @current_player.color, @turn_count, @current_player.castling_used, @current_player.check)
    if (move_results.include?("Invalid"))
      puts move_results
      return move_results
    elsif (move_results.include?("Castling performed"))
      if (@current_player.color == "white")
        @player_one.castling_used = true
      elsif (@current_player.color == "black")
        @player_two.castling_used = true
      end
      puts move_results
    else
      puts move_results
    end

    # Update the piece data that was moved
    @game_board.update_piece(finish, @turn_count)

    # Handling of promotion input
    unless (@game_board.find_promotion.nil?)
      @game_board.promote_pawn(find_promotion, promotion_choice)
    end

    move_results
  end

  def convert_to_index(chr)
    position_swaps = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, 
      "g" => 6, "h" => 7}

    coord = -5
    if (position_swaps[chr].nil?)
      coord = (chr.to_i - 8).abs
    else
      coord = position_swaps[chr]
    end
    coord
  end

  def promotion_choice
    puts "There is a pawn available for promotion."
    puts "Which piece type would you like to upgrade to? Select from Q, B, R, and N."
    piece_format = /^[QBRN](?!.)/
    piece_choice = "invalid piece"
    piece_choice = gets.chomp.upcase

    while piece_format.match(piece_choice).nil? do
      puts "Invalid piece choice input, try again."
      move_start = gets.chomp.upcase
    end

    piece_choice
  end

  def player_check
    if (@current_player.color == "white")
      if (@game_board.check?(@game_board.find_king("black"), "black"))
        if (@game_board.checkmate?("black"))
          announce_results(@current_player)
        else
          @player_two.check = true
        end
      end
    elsif (@current_player.color == "black")
      if (@game_board.check?(@game_board.find_king("white"), "white"))
        if (@game_board.checkmate?("white"))
          announce_results(@current_player)
        else
          @player_one.check = true
        end
      end
    end
  end

  def resign
    if (@current_player == @player_one)
      announce_results(@player_two)
    else
      announce_results(@player_one)
    end
  end

  def save_game
    # Save our game outside of the lib folder.
    File.write("../save.yml", self.to_yaml)
    puts "Your game was saved!\n\n"
    player_turn
  end

  def load_game
    # Load a saved game from outside of the lib directory, start a new game otherwise.
    begin
      load = YAML::load_file("../save.yml")
      puts "Game successfully loaded, let's continue!\n\n"
      load.play
    rescue
      puts "There is no existing save file."
      puts "Let's start a new game then!\n\n"
      new_game
    end
  end

  def change_turn
    @turn_count += 1
    if (@current_player == @player_one)
      @current_player = @player_two
    elsif (@current_player == @player_two)
      @current_player = @player_one
    end
    puts "\nBeginning turn #{@turn_count}."
  end

  def announce_results(player)
    puts "\n#{@game_board.display_board}"
    puts "Congratulations #{player.name}, you're the winner!"
    exit(0)
  end

  def new_game
    instructions
    assign_players
    new_board
    play
  end

  def play
    # Keep looping until the game is over
    # If the game is loaded call directly into play
    loop do
      player_turn
      player_check
      change_turn
    end
  end

end