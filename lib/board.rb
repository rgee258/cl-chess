class Board

	attr_reader :board

  def initialize
    @board = []
  end

  # Game setup

  def create_board
  	8.times do
  		@board.push([nil, nil, nil, nil, nil, nil, nil, nil])
  	end
  end

  def add_pieces
  	add_kings
  	add_queens
  	add_bishops
  	add_knights
  	add_rooks
  	add_pawns
  end

  def add_kings
  	@board[0][4] = Piece.new("K", "black")
  	@board[7][4] = Piece.new("K", "white")
  end

  def add_queens
  	@board[0][3] = Piece.new("Q", "black")
  	@board[7][3] = Piece.new("Q", "white")
  end

  def add_bishops
  	@board[0][2] = Piece.new("B", "black")
  	@board[0][5] = Piece.new("B", "black")
  	@board[7][2] = Piece.new("B", "white")
  	@board[7][5] = Piece.new("B", "white")
  end

  def add_knights
  	@board[0][1] = Piece.new("N", "black")
  	@board[0][6] = Piece.new("N", "black")
  	@board[7][1] = Piece.new("N", "white")
  	@board[7][6] = Piece.new("N", "white")
  end

  def add_rooks
  	@board[0][0] = Piece.new("R", "black")
  	@board[0][7] = Piece.new("R", "black")
  	@board[7][0] = Piece.new("R", "white")
  	@board[7][7] = Piece.new("R", "white")
  end

  def add_pawns
  	@board[1][0] = Piece.new("P", "black")
  	@board[1][1] = Piece.new("P", "black")
  	@board[1][2] = Piece.new("P", "black")
  	@board[1][3] = Piece.new("P", "black")
  	@board[1][4] = Piece.new("P", "black")
  	@board[1][5] = Piece.new("P", "black")
  	@board[1][6] = Piece.new("P", "black")
  	@board[1][7] = Piece.new("P", "black")
  	@board[6][0] = Piece.new("P", "white")
  	@board[6][1] = Piece.new("P", "white")
  	@board[6][2] = Piece.new("P", "white")
  	@board[6][3] = Piece.new("P", "white")
  	@board[6][4] = Piece.new("P", "white")
  	@board[6][5] = Piece.new("P", "white")
  	@board[6][6] = Piece.new("P", "white")
  	@board[6][7] = Piece.new("P", "white")
  end

  def display_board
    display = ""

    @board.each do |row|
      display << "-----------------\n"
      row.each do |col|
        if col.nil?
          display << "| "
        else
          display << "|#{col.type}"
        end
      end
      display << "|\n"
    end
    display << "-----------------"
 
    display
  end

  def move_piece(start, finish, turn_color)

    # HOW do we keep track of which side's piece can move for the current turn?
    # Perhaps pass in the current color and do it that way for the starting piece?

    # If we're starting at a place that's nil just point that piece there and make the original nil
    # If we're capturing a piece, make the finish position nil, change it to the original, and then nil the origin

    # Invalid start piece movement
    if (@board[start[0]][start[1]].nil?)
      return "Invalid piece movement, try again."
    end

    # Invalid starting piece color
    if (@board[start[0]][start[1]].color != turn_color) 
      return "Invalid piece movement, try again."
    end

    # Return a string stating the move OR
    # Return that the move was invalid

    # Call example: valid_move?(@board[start[0]][start[1]].type, turn_color, )
  end

  def valid_move?(type, turn_color, valid_start, valid_finish)
  	# Going need to call a number of methods available for checking the different pieces
    # Check criteria: start nil, invalid start piece, invalid end pos
    if (type == "K")
      # Call validity checks
    end
  end

  def valid_queen?(valid_start, valid_finish)
    moves = []

    # Take every direction, loop possible moves in that direction until it reaches a piece or end of the board
    # If a piece is reached, check the type and color of the piece and if valid, add it to the list of available moves
  end

  def valid_pawn_white?(valid_start, valid_finish)
    moves = []

    # Case for moving forward
    # Case for moving diagonally left or right if an opposite piece is there except for a king
    if (valid_start[0] > 0)
      if (@board[valid_start[0] - 1][valid_start[1]].nil?)
        # Push to move the forward movement
      end

      # Code for checking if the diagonal left and right are valid for capturing
    end
  end

  def valid_pawn_black?(valid_start, valid_finish)
    moves = []
  end

  def promotion_white
  end

  def promotion_black
  end

  def check?
  end

  def checkmate?
  end

end