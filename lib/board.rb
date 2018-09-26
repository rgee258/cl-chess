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
    if (valid_move?(start, finish, turn_color))
      @board[finish[0]][finish[1]] = @board[start[0]][start[1]]
      @board[start[0]][start[1]] = nil
      "Piece moved."
    else
      # Castling movement
      if (@board[start[0]][start[1]].type == "K" && @board[start[0]][start[1]].move_counter == 0)
        "Invalid piece movement, try again."
      end
    end
  end

  def castling
    # Code for castling here
    "Castling performed."
  end

  def valid_move?(start, finish, turn_color)
  	# Going need to call a number of methods available for checking the different pieces
    # Check criteria: start nil, invalid start piece, invalid end pos
    piece_type = @board[start[0]][start[1]].type

    # Call validity checks based on piece type
    if (piece_type == "K")
    elsif (piece_type == "Q")
      return valid_queen?(start, finish, turn_color)
    elsif (piece_type == "B")
      return valid_bishop?(start, finish, turn_color)
    elsif (piece_type == "R")
      return valid_rook?(start, finish, turn_color) 
    elsif (piece_type == "N")
      return valid_knight?(start, finish, turn_color)  
    elsif (piece_type == "P")
      return valid_pawn?(start, finish, turn_color)
    end

    false
  end

  def valid_queen?(start, finish, turn_color)
    moves = []
    check  = -5

    # Use path finding from the rook

    # All moves going up
    check = start[0]
    while (check > 0)
      if (@board[check - 1][start[1]].nil?)
        moves.push([check - 1, start[1]])
      elsif (@board[check - 1][start[1]].color != turn_color)
        moves.push([check - 1, start[1]])
        break
      elsif (@board[check - 1][start[1]].color == turn_color)
        break
      end
      check -= 1
    end

    # All moves going down
    check = start[0]
    while (check < 7)
      if (@board[check + 1][start[1]].nil?)
        moves.push([check + 1, start[1]])
      elsif (@board[check + 1][start[1]].color != turn_color)
        moves.push([check + 1, start[1]])
        break
      elsif (@board[check + 1][start[1]].color == turn_color)
        break
      end
      check += 1
    end

    # All moves going left
    check = start[1]
    while (check > 0)
      if (@board[start[0]][check - 1].nil?)
        moves.push([start[0], check - 1])
      elsif (@board[start[0]][check - 1].color != turn_color)
        moves.push([start[0], check - 1])
        break
      elsif (@board[start[0]][check - 1].color == turn_color)
        break
      end
      check -= 1
    end

    # All moves going right
    check = start[1]
    while (check < 7)
      if (@board[start[0]][check + 1].nil?)
        moves.push([start[0], check + 1])
      elsif (@board[start[0]][check + 1].color != turn_color)
        moves.push([start[0], check + 1])
        break
      elsif (@board[start[0]][check + 1].color == turn_color)
        break
      end
      check += 1
    end

    # Use path finding from the bishop

    # All moves going up left diagonal
    check = [start[0], start[1]]
    while (check[0] > 0 && check[1] > 0)
      if (@board[check[0] - 1][check[1] - 1].nil?)
        moves.push([check[0] - 1, check[1] - 1])
      elsif (@board[check[0] - 1][check[1] - 1].color != turn_color)
        moves.push([check[0] - 1, check[1] - 1])
        break
      elsif (@board[check[0] - 1][check[1] - 1].color == turn_color)
        break
      end
      check[0] -= 1
      check[1] -= 1
    end

    # All moves going up right diagonal
    check = [start[0], start[1]]
    while (check[0] > 0 && check[1] < 7)
      if (@board[check[0] - 1][check[1] + 1].nil?)
        moves.push([check[0] - 1, check[1] + 1])
      elsif (@board[check[0] - 1][check[1] + 1].color != turn_color)
        moves.push([check[0] - 1, check[1] + 1])
        break
      elsif (@board[check[0] - 1][check[1] + 1].color == turn_color)
        break
      end
      check[0] -= 1
      check[1] += 1
    end

    # All moves going down left diagonal
    check = [start[0], start[1]]
    while (check[0] < 7 && check[1] > 0)
      if (@board[check[0] + 1][check[1] - 1].nil?)
        moves.push([check[0] + 1, check[1] - 1])
      elsif (@board[check[0] + 1][check[1] - 1].color != turn_color)
        moves.push([check[0] + 1, check[1] - 1])
        break
      elsif (@board[check[0] + 1][check[1] - 1].color == turn_color)
        break
      end
      check[0] += 1
      check[1] -= 1
    end

    # All moves going down right diagonal
    check = [start[0], start[1]]
    while (check[0] < 7 && check[1] < 7)
      if (@board[check[0] + 1][check[1] + 1].nil?)
        moves.push([check[0] + 1, check[1] + 1])
      elsif (@board[check[0] + 1][check[1] + 1].color != turn_color)
        moves.push([check[0] + 1, check[1] + 1])
        break
      elsif (@board[check[0] + 1][check[1] + 1].color == turn_color)
        break
      end
      check[0] += 1
      check[1] += 1
    end

    # Check if the movement is valid from the possible available moves
    moves.each do |move|
      return true if move == finish
    end

    false
  end

  def valid_bishop?(start, finish, turn_color)
    moves = []
    check = -5

    # All moves going up left diagonal
    check = [start[0], start[1]]
    while (check[0] > 0 && check[1] > 0)
      if (@board[check[0] - 1][check[1] - 1].nil?)
        moves.push([check[0] - 1, check[1] - 1])
      elsif (@board[check[0] - 1][check[1] - 1].color != turn_color)
        moves.push([check[0] - 1, check[1] - 1])
        break
      elsif (@board[check[0] - 1][check[1] - 1].color == turn_color)
        break
      end
      check[0] -= 1
      check[1] -= 1
    end

    # All moves going up right diagonal
    check = [start[0], start[1]]
    while (check[0] > 0 && check[1] < 7)
      if (@board[check[0] - 1][check[1] + 1].nil?)
        moves.push([check[0] - 1, check[1] + 1])
      elsif (@board[check[0] - 1][check[1] + 1].color != turn_color)
        moves.push([check[0] - 1, check[1] + 1])
        break
      elsif (@board[check[0] - 1][check[1] + 1].color == turn_color)
        break
      end
      check[0] -= 1
      check[1] += 1
    end

    # All moves going down left diagonal
    check = [start[0], start[1]]
    while (check[0] < 7 && check[1] > 0)
      if (@board[check[0] + 1][check[1] - 1].nil?)
        moves.push([check[0] + 1, check[1] - 1])
      elsif (@board[check[0] + 1][check[1] - 1].color != turn_color)
        moves.push([check[0] + 1, check[1] - 1])
        break
      elsif (@board[check[0] + 1][check[1] - 1].color == turn_color)
        break
      end
      check[0] += 1
      check[1] -= 1
    end

    # All moves going down right diagonal
    check = [start[0], start[1]]
    while (check[0] < 7 && check[1] < 7)
      if (@board[check[0] + 1][check[1] + 1].nil?)
        moves.push([check[0] + 1, check[1] + 1])
      elsif (@board[check[0] + 1][check[1] + 1].color != turn_color)
        moves.push([check[0] + 1, check[1] + 1])
        break
      elsif (@board[check[0] + 1][check[1] + 1].color == turn_color)
        break
      end
      check[0] += 1
      check[1] += 1
    end

    # Check if the movement is valid from the possible available moves
    moves.each do |move|
      return true if move == finish
    end

    false
  end

  def valid_rook?(start, finish, turn_color)
    moves = []
    check = -5

    # All moves going up
    check = start[0]
    while (check > 0)
      if (@board[check - 1][start[1]].nil?)
        moves.push([check - 1, start[1]])
      elsif (@board[check - 1][start[1]].color != turn_color)
        moves.push([check - 1, start[1]])
        break
      elsif (@board[check - 1][start[1]].color == turn_color)
        break
      end
      check -= 1
    end

    # All moves going down
    check = start[0]
    while (check < 7)
      if (@board[check + 1][start[1]].nil?)
        moves.push([check + 1, start[1]])
      elsif (@board[check + 1][start[1]].color != turn_color)
        moves.push([check + 1, start[1]])
        break
      elsif (@board[check + 1][start[1]].color == turn_color)
        break
      end
      check += 1
    end

    # All moves going left
    check = start[1]
    while (check > 0)
      if (@board[start[0]][check - 1].nil?)
        moves.push([start[0], check - 1])
      elsif (@board[start[0]][check - 1].color != turn_color)
        moves.push([start[0], check - 1])
        break
      elsif (@board[start[0]][check - 1].color == turn_color)
        break
      end
      check -= 1
    end

    # All moves going right
    check = start[1]
    while (check < 7)
      if (@board[start[0]][check + 1].nil?)
        moves.push([start[0], check + 1])
      elsif (@board[start[0]][check + 1].color != turn_color)
        moves.push([start[0], check + 1])
        break
      elsif (@board[start[0]][check + 1].color == turn_color)
        break
      end
      check += 1
    end

    # Check if the movement is valid from the possible available moves
    moves.each do |move|
      return true if move == finish
    end

    false
  end

  def valid_knight?(start, finish, turn_color)
    moves = []

    # Up 2, left 1
    if (start[0] > 1 && start[1] > 0)
      if (@board[start[0] - 2][start[1] - 1].nil?)
        moves.push([start[0] - 2, start[1] - 1])
      elsif (@board[start[0] - 2][start[1] - 1].color != turn_color)
        moves.push([start[0] - 2, start[1] - 1])
      end
    end

    # Up 2, right 1
    if (start[0] > 1 && start[1] < 7)
      if (@board[start[0] - 2][start[1] + 1].nil?)
        moves.push([start[0] - 2, start[1] + 1])
      elsif (@board[start[0] - 2][start[1] + 1].color != turn_color)
        moves.push([start[0] - 2, start[1] + 1])
      end
    end

    # Left 2, up 1
    if (start[0] > 0 && start[1] > 1)
      if (@board[start[0] - 1][start[1] - 2].nil?)
        moves.push([start[0] - 1, start[1] - 2])
      elsif (@board[start[0] - 1][start[1] - 2].color != turn_color)
        moves.push([start[0] - 1, start[1] - 2])
      end
    end

    # Left 2, down 1
    if (start[0] < 7 && start[1] > 1)
      if (@board[start[0] + 1][start[1] - 2].nil?)
        moves.push([start[0] + 1, start[1] - 2])
      elsif (@board[start[0] + 1][start[1] - 2].color != turn_color)
        moves.push([start[0] + 1, start[1] - 2])
      end
    end

    # Right 2, up 1
    if (start[0] > 0 && start[1] < 6)
      if (@board[start[0] - 1][start[1] + 2].nil?)
        moves.push([start[0] - 1, start[1] + 2])
      elsif (@board[start[0] - 1][start[1] + 2].color != turn_color)
        moves.push([start[0] - 1, start[1] + 2])
      end
    end

    # Right 2, down 1
    if (start[0] < 7 && start[1] < 6)
      if (@board[start[0] + 1][start[1] + 2].nil?)
        moves.push([start[0] + 1, start[1] + 2])
      elsif (@board[start[0] + 1][start[1] + 2].color != turn_color)
        moves.push([start[0] + 1, start[1] + 2])
      end
    end

    # Down 2, left 1
    if (start[0] < 6 && start[1] > 0)
      if (@board[start[0] + 2][start[1] - 1].nil?)
        moves.push([start[0] + 2, start[1] - 1])
      elsif (@board[start[0] + 2][start[1] - 1].color != turn_color)
        moves.push([start[0] + 2, start[1] - 1])
      end
    end

    # Down 2, right 1
    if (start[0] < 6 && start[1] < 7)
      if (@board[start[0] + 2][start[1] + 1].nil?)
        moves.push([start[0] + 2, start[1] + 1])
      elsif (@board[start[0] + 2][start[1] + 1].color != turn_color)
        moves.push([start[0] + 2, start[1] + 1])
      end
    end

    # Check if the movement is valid from the possible available moves
    moves.each do |move|
      return true if move == finish
    end

    false
  end

  def valid_pawn?(start, finish, turn_color)
    moves = []

    if (turn_color == "white")
      if (start[0] > 0)
        # Moving forward by 1
        if (@board[start[0] - 1][start[1]].nil?)
          moves.push([start[0] - 1, start[1]])
        end

        # Moving forward by 2 if the pawn hasn't moved
        if (@board[start[0]][start[1]].move_counter == 0)
          if (@board[start[0] - 2][start[1]].nil?)
            moves.push([start[0] - 2, start[1]])
          end
        end

        # Check the diagonal left for a capture piece
        unless (@board[start[0] - 1][start[1] - 1].nil?)
          if (@board[start[0] - 1][start[1] - 1].color != turn_color && 
            @board[start[0] - 1][start[1] - 1].type != "K")
            moves.push([start[0] - 1, start[1] - 1])
          end
        end

        # Check the diagonal right for a capture piece
        unless (@board[start[0] - 1][start[1] + 1].nil?)
          if (@board[start[0] - 1][start[1] + 1].color != turn_color && 
            @board[start[0] - 1][start[1] + 1].type != "K")
            moves.push([start[0] - 1, start[1] + 1])
          end
        end
      end
    end

    if (turn_color == "black")
      if (start[0] < 7)
        # Moving forward by 1
        if (@board[start[0] + 1][start[1]].nil?)
          moves.push([start[0] + 1, start[1]])
        end

        # Moving forward by 2 if the pawn hasn't moved
        if (@board[start[0]][start[1]].move_counter == 0)
          if (@board[start[0] + 2][start[1]].nil?)
            moves.push([start[0] + 2, start[1]])
          end
        end

        # Check the diagonal left for a capture piece
        unless (@board[start[0] + 1][start[1] - 1].nil?)
          if (@board[start[0] + 1][start[1] - 1].color != turn_color && 
            @board[start[0] + 1][start[1] - 1].type != "K")
            moves.push([start[0] + 1, start[1] - 1])
          end
        end

        # Check the diagonal right for a capture piece
        unless (@board[start[0] + 1][start[1] + 1].nil?)
          if (@board[start[0] + 1][start[1] + 1].color != turn_color && 
            @board[start[0] + 1][start[1] + 1].type != "K")
            moves.push([start[0] + 1, start[1] + 1])
          end
        end
      end
    end

    # Check if the movement is valid from the possible available moves
    moves.each do |move|
      return true if move == finish
    end

    false
  end

  def promotion_check
  end

  def promotion_choice
  end

  def check?
    # Reuse the above code, doing the movement of a queen (rook + bishop) and knight from the king start
    # Identify specific cases (pawn) based off of bishop
    # If a piece is found that can reach the king and is of opposite color then mark for check
    # Set the player check value to true
  end

  def checkmate?
  end

end