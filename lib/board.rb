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
      display << "-------------------------\n"
      row.each do |col|
        if col.nil?
          display << "|  "
        else
          display << "|#{col.type}"
          if (col.color == "white")
            display << "w"
          elsif (col.color == "black")
            display << "b"
          end
        end
      end
      display << "|\n"
    end
    display << "-------------------------"
 
    display
  end

  def move_piece(start, finish, turn_color, turn_count, castling_used, in_check)

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
      return "Piece moved."
    end

    # Logic for calling the en passant and castling methods
    if (@board[start[0]][start[1]].type == "P")
      # En passant call
    elsif (@board[start[0]][start[1]].type == "K")
      # Castling call
    end

    "Invalid piece movement, try again."
  end

  # Going to need something for moving a piece when the player is in check

  def update_piece(update_position, turn_count)
    @board[update_position[0]][update_position[1]].last_moved = turn_count
    @board[update_position[0]][update_position[1]].times_moved += 1
    "Piece updated."
  end

  def castling(king_start, king_finish, turn_color, castling_used)
    # Code for castling here
    if (castling_used == false)
      if (turn_color == "white")
        # Right rook
        if (king_start == [7, 4] && king_finish == [7, 6] && @board[king_start[0]][king_start[1]].last_moved == 0)
          # Check if both spots to the right are empty
          if (@board[7][5].nil? && @board[7][6].nil?)
            unless (@board[7][7].nil?)
              # Check rook requirements
              if (@board[7][7].type == "R" && @board[7][7].last_moved == 0)
                # Use unless to ensure the king positions being moved do not result in check
                unless (check?([7, 5], "white"))
                  unless (check?([7, 6], "white"))
                    @board[7][6] = @board[7][4]
                    @board[7][4] = nil
                    @board[7][5] = @board[7][7]
                    @board[7][7] = nil
                    return "Castling performed."
                  end
                end
              end
            end
          end
        # Left rook
        elsif (king_start == [7, 4] && king_finish == [7, 2] && @board[king_start[0]][king_start[1]].last_moved == 0)  
          # Check if both spots to the left are empty
          if (@board[7][3].nil? && @board[7][2].nil?)
            unless (@board[7][0].nil?)
              # Check rook requirements
              if (@board[7][0].type == "R" && @board[7][0].last_moved == 0)
                # Use unless to ensure the king positions being moved do not result in check
                unless (check?([7, 3], "white"))
                  unless (check?([7, 2], "white"))
                    @board[7][2] = @board[7][4]
                    @board[7][4] = nil
                    @board[7][3] = @board[7][0]
                    @board[7][0] = nil
                    return "Castling performed."
                  end
                end
              end
            end
          end
        end
      elsif (turn_color == "black")
        # Right rook
        if (king_start == [0, 4] && king_finish == [0, 6] && @board[king_start[0]][king_start[1]].last_moved == 0)
          # Check if both spots to the right are empty
          if (@board[0][5].nil? && @board[0][6].nil?)
            unless (@board[0][7].nil?)
              # Check rook requirements
              if (@board[0][7].type == "R" && @board[0][7].last_moved == 0)
                # Use unless to ensure the king positions being moved do not result in check
                unless (check?([0, 5], "black"))
                  unless (check?([0, 6], "black"))
                    @board[0][6] = @board[0][4]
                    @board[0][4] = nil
                    @board[0][5] = @board[0][7]
                    @board[0][7] = nil
                    return "Castling performed."
                  end
                end
              end
            end
          end
        # Left rook
        elsif (king_start == [0, 4] && king_finish == [0, 2] && @board[king_start[0]][king_start[1]].last_moved == 0)  
          # Check if both spots to the left are empty
          if (@board[0][3].nil? && @board[0][2].nil?)
            unless (@board[0][0].nil?)
              # Check rook requirements
              if (@board[0][0].type == "R" && @board[0][0].last_moved == 0)
                # Use unless to ensure the king positions being moved do not result in check
                unless (check?([0, 3], "black"))
                  unless (check?([0, 2], "black"))
                    @board[0][2] = @board[7][4]
                    @board[0][4] = nil
                    @board[0][3] = @board[7][0]
                    @board[0][0] = nil
                    return "Castling performed."
                  end
                end
              end
            end
          end
        end
      end
    end
    "Invalid piece movement, try again."
  end

  def en_passant(start, finish, turn_color, turn_count)
    if (turn_color == "white")
      if (start[0] == 3)
        # Adjacent left
        unless(@board[3][start[1] - 1].nil?)
          if (@board[3][start[1] - 1].type == "P")
            if (finish[0] == 2 && finish[1] == start[1] - 1)
              if (@board[3][start[1] - 1].last_moved == turn_count - 1 && @board[3][start[1] - 1].times_moved == 1)
                @board[2][finish[1]] = @board[start[0]][start[1]]
                @board[start[0]][start[1]] = nil
                @board[3][start[1] - 1] = nil
                return "En passant performed."
              end
            end
          end
        end
        # Adjacent right
        unless(@board[3][start[1] + 1].nil?)
          if (@board[3][start[1] + 1].type == "P")
            if (finish[0] == 2 && finish[1] == start[1] + 1)
              if (@board[3][start[1] + 1].last_moved == turn_count - 1 && @board[3][start[1] + 1].times_moved == 1)
                @board[2][finish[1]] = @board[start[0]][start[1]]
                @board[start[0]][start[1]] = nil
                @board[3][start[1] + 1] = nil
                return "En passant performed."
              end
            end
          end
        end
      end
    elsif (turn_color == "black")
      if (start[0] == 4)
        # Adjacent left
        unless(@board[4][start[1] - 1].nil?)
          if (@board[4][start[1] - 1].type == "P")
            if (finish[0] == 5 && finish[1] == start[1] - 1)
              if (@board[4][start[1] - 1].last_moved == turn_count - 1 && @board[4][start[1] - 1].times_moved == 1)
                @board[5][finish[1]] = @board[start[0]][start[1]]
                @board[start[0]][start[1]] = nil
                @board[4][start[1] - 1] = nil
                return "En passant performed."
              end
            end
          end
        end
        # Adjacent right
        unless(@board[4][start[1] + 1].nil?)
          if (@board[4][start[1] + 1].type == "P")
            if (finish[0] == 5 && finish[1] == start[1] + 1)
              if (@board[4][start[1] + 1].last_moved == turn_count - 1 && @board[4][start[1] + 1].times_moved == 1)
                @board[5][finish[1]] = @board[start[0]][start[1]]
                @board[start[0]][start[1]] = nil
                @board[4][start[1] + 1] = nil
                return "En passant performed."
              end
            end
          end
        end
      end
    end

    "Invalid piece movement, try again."
  end

  def valid_move?(start, finish, turn_color)
    # Going need to call a number of methods available for checking the different pieces
    # Check criteria: start nil, invalid start piece, invalid end pos
    piece_type = @board[start[0]][start[1]].type

    # Call validity checks based on piece type
    if (piece_type == "K")
      return valid_king?(start, finish, turn_color)
      # Put these in an if, make a separate method for handling king moves in check
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

  def valid_king?(start, finish, turn_color)
    moves = []

    # Move up
    if (start[0] > 0)
      if (@board[start[0] - 1][start[1]].nil?)
        moves.push([start[0] - 1, start[1]])
      elsif (@board[start[0] - 1][start[1]].color != turn_color)
        moves.push([start[0] - 1, start[1]])
      end

      # Move up and left
      if (start[1] > 0)
        if (@board[start[0] - 1][start[1] - 1].nil?)
          moves.push([start[0] - 1, start[1] - 1])
        elsif (@board[start[0] - 1][start[1] - 1].color != turn_color)
          moves.push([start[0] - 1, start[1] - 1])
        end
      end

      # Move up and right
      if (start[1] < 7)
        if (@board[start[0] - 1][start[1] + 1].nil?)
          moves.push([start[0] - 1, start[1] + 1])
        elsif (@board[start[0] - 1][start[1] + 1].color != turn_color)
          moves.push([start[0] - 1, start[1] + 1])
        end
      end
    end

    # Move down
    if (start[0] < 7)
      if (@board[start[0] + 1][start[1]].nil?)
        moves.push([start[0] + 1, start[1]])
      elsif (@board[start[0] + 1][start[1]].color != turn_color)
        moves.push([start[0] + 1, start[1]])
      end

      # Move up and left
      if (start[1] > 0)
        if (@board[start[0] + 1][start[1] - 1].nil?)
          moves.push([start[0] + 1, start[1] - 1])
        elsif (@board[start[0] + 1][start[1] - 1].color != turn_color)
          moves.push([start[0] + 1, start[1] - 1])
        end
      end

      # Move up and right
      if (start[1] < 7)
        if (@board[start[0] + 1][start[1] + 1].nil?)
          moves.push([start[0] + 1, start[1] + 1])
        elsif (@board[start[0] + 1][start[1] + 1].color != turn_color)
          moves.push([start[0] + 1, start[1] + 1])
        end
      end
    end

    # Move left
    if (start[1] > 0)
      if (@board[start[0]][start[1] - 1].nil?)
        moves.push([start[0], start[1] - 1])
      elsif (@board[start[0]][start[1] - 1].color != turn_color)
        moves.push([start[0], start[1] - 1])
      end
    end

    # Move right
    if (start[1] < 7)
      if (@board[start[0]][start[1] + 1].nil?)
        moves.push([start[0], start[1] + 1])
      elsif (@board[start[0]][start[1] + 1].color != turn_color)
        moves.push([start[0], start[1] + 1])
      end
    end

    # ---Check here for removing moves that place you in check?

    # Check if the movement is valid from the possible available moves
    moves.each do |move|
      return true if move == finish
    end

    false

  end

  def valid_queen?(start, finish, turn_color)
    moves = []
    check = -5

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
      end
      check[0] -= 1
      check[1] -= 1
    end

    # All moves going up right diagonal
    check = [start[0], start[1]]
    while (check[0] > 0 && check[1] < 7)
      if (@board[check[0] - 1][check[1] + 1].nil?)
        moves.push([check[0] - 1, check[1] + 1])
      end
      check[0] -= 1
      check[1] += 1
    end

    # All moves going down left diagonal
    check = [start[0], start[1]]
    while (check[0] < 7 && check[1] > 0)
      if (@board[check[0] + 1][check[1] - 1].nil?)
        moves.push([check[0] + 1, check[1] - 1])
      end
      check[0] += 1
      check[1] -= 1
    end

    # All moves going down right diagonal
    check = [start[0], start[1]]
    while (check[0] < 7 && check[1] < 7)
      if (@board[check[0] + 1][check[1] + 1].nil?)
        moves.push([check[0] + 1, check[1] + 1])
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
        if (@board[start[0]][start[1]].last_moved == 0)
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
        if (@board[start[0]][start[1]].last_moved == 0)
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

  def find_promotion
    8.times do |col|
      unless (@board[0][col].nil?)
        return [0, col] if @board[0][col].type == "P"
      end
      unless (@board[7][col].nil?)
        return [7, col] if @board[7][col].type == "P"
      end
    end

    nil
  end

  def promote_pawn(position, piece)
    @board[position[0]][position[1]].type = piece
  end

  def find_king(turn_color)
    8.times do |row|
      8.times do |col|
        unless (@board[row][col].nil?)
          return [row, col] if (@board[row][col].type == "K" && @board[row][col].color == turn_color)
        end
      end  
    end
    "ERROR: King not found."
  end

  def check?(king_position, turn_color)
    # Reuse the above code, doing the movement of a queen (rook + bishop) and knight from the king start
    # Identify specific cases (pawn) based off of bishop
    # If a piece is found that can reach the king and is of opposite color then mark for check
    # Set the player check value to true

    # White king
    if (turn_color == "white")
      # Check for pawns
      unless (@board[king_position[0] - 1][king_position[1] - 1].nil?)
        # Left pawn
        if (@board[king_position[0] - 1][king_position[1] - 1].type == "P" && @board[king_position[0] - 1][king_position[1] - 1].color == "black")
          return true
        end
      end
      unless (@board[king_position[0] - 1][king_position[1] + 1].nil?)
        # Right pawn
        if (@board[king_position[0] - 1][king_position[1] + 1].type == "P" && @board[king_position[0] - 1][king_position[1] + 1].color == "black")
          return true
        end
      end

      # Check for knights
      # Knight located up 2, left 1
      if (king_position[0] > 1 && king_position[1] > 0)
        unless (@board[king_position[0] - 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] - 1].type == "N" && @board[king_position[0] - 2][king_position[1] - 1].color == "black")
            return true
          end
        end
      end
      # Knight located up 2, right 1
      if (king_position[0] > 1 && king_position[1] < 7)
        unless (@board[king_position[0] - 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] + 1].type == "N" && @board[king_position[0] - 2][king_position[1] - 1].color == "black")
            return true
          end
        end
      end
      # Knight located left 2, up 1
      if (king_position[0] > 0 && king_position[1] > 1)
        unless (@board[king_position[0] - 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] - 2].type == "N" && @board[king_position[0] - 1][king_position[1] - 2].color == "black")
            return true
          end
        end
      end
      # Knight located left 2, down 1
      if (king_position[0] < 7 && king_position[1] > 1)
        unless (@board[king_position[0] + 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] - 2].type == "N" && @board[king_position[0] + 1][king_position[1] - 2].color == "black")
            return true
          end
        end
      end
      # Knight located right 2, up 1
      if (king_position[0] > 0 && king_position[1] < 6)
        unless (@board[king_position[0] - 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] + 2].type == "N" && @board[king_position[0] - 1][king_position[1] + 2].color == "black")
            return true
          end
        end
      end
      # Knight located right 2, down 1
      if (king_position[0] < 7 && king_position[1] < 6)
        unless (@board[king_position[0] + 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] + 2].type == "N" && @board[king_position[0] + 1][king_position[1] + 2].color == "black")
            return true
          end
        end
      end
      # Knight located down 2, left 1
      if (king_position[0] < 6 && king_position[1] > 0)
        unless (@board[king_position[0] + 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] + 2][king_position[1] - 1].type == "N" && @board[king_position[0] + 2][king_position[1] - 1].color == "black")
            return true
          end
        end
      end
      # Knight located down 2, right 1
      if (king_position[0] < 6 && king_position[1] < 7)
        unless (@board[king_position[0] + 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] + 2][king_position[1] + 1].type == "N" && @board[king_position[0] + 2][king_position[1] + 1].color == "black")
            return true
          end
        end
      end

      # Check for rooks and queens
      check = 0
      # All moves going up
      check = king_position[0]
      while (check > 0)
        until (@board[check - 1][king_position[1]].nil?)
          if (@board[check - 1][king_position[1]].type == "R" && @board[check - 1][king_position[1]].color == "black")
            return true
          elsif (@board[check - 1][king_position[1]].type == "Q" && @board[check - 1][king_position[1]].color == "black")
            return true
          end
          break
        end
        check -= 1
      end
      # All moves going down
      check = king_position[0]
      while (check < 7)
        until (@board[check + 1][king_position[1]].nil?)
          if (@board[check + 1][king_position[1]].type == "R" && @board[check + 1][king_position[1]].color == "black")
            return true
          elsif (@board[check + 1][king_position[1]].type == "Q" && @board[check + 1][king_position[1]].color == "black")
            return true
          end
          break
        end
        check += 1
      end
      # All moves going left
      check = king_position[1]
      while (check > 0)
        until (@board[king_position[0]][check - 1].nil?)
          if (@board[king_position[0]][check - 1].type == "R" && @board[king_position[0]][check - 1].color == "black")
            return true
          elsif (@board[king_position[0]][check - 1].type == "Q" && @board[king_position[0]][check - 1].color == "black")
            return true
          end
          break
        end
        check -= 1
      end
      # All moves going right
      check = king_position[1]
      while (check < 7)
        until (@board[king_position[0]][check + 1].nil?)
          if (@board[king_position[0]][check + 1].type == "R" && @board[king_position[0]][check + 1].color == "black")
            return true
          elsif (@board[king_position[0]][check + 1].type == "Q" && @board[king_position[0]][check + 1].color == "black")
            return true
          end
          break
        end
        check += 1
      end

      # Check for bishops and queens
      # All moves going up left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] > 0)
        until (@board[check[0] - 1][check[1] - 1].nil?)
          if (@board[check[0] - 1][check[1] - 1].type == "B" && @board[check[0] - 1][check[1] - 1].color == "black")
            return true
          elsif (@board[check[0] - 1][check[1] - 1].type == "Q" && @board[check[0] - 1][check[1] - 1].color == "black")
            return true
          end
          break
        end
        check[0] -= 1
        check[1] -= 1
      end
      # All moves going up right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] < 7)
        until (@board[check[0] - 1][check[1] + 1].nil?)
          if (@board[check[0] - 1][check[1] + 1].type == "B" && @board[check[0] - 1][check[1] + 1].color == "black")
            return true
          elsif (@board[check[0] - 1][check[1] + 1].type == "Q" && @board[check[0] - 1][check[1] + 1].color == "black")
            return true
          end
          break
        end
        check[0] -= 1
        check[1] += 1
      end
      # All moves going down left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] > 0)
        until (@board[check[0] + 1][check[1] - 1].nil?)
          if (@board[check[0] + 1][check[1] - 1].type == "B" && @board[check[0] + 1][check[1] - 1].color == "black")
            return true
          elsif (@board[check[0] + 1][check[1] - 1].type == "Q" && @board[check[0] + 1][check[1] - 1].color == "black")
            return true
          end
          break
        end
        check[0] += 1
        check[1] -= 1
      end
      # All moves going down right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] < 7)
        until (@board[check[0] + 1][check[1] + 1].nil?)
          if (@board[check[0] + 1][check[1] + 1].type == "B" && @board[check[0] + 1][check[1] + 1].color == "black")
            return true
          elsif (@board[check[0] + 1][check[1] + 1].type == "Q" && @board[check[0] + 1][check[1] + 1].color == "black")
            return true
          end
          break
        end
        check[0] += 1
        check[1] += 1
      end

    # Black king
    elsif (turn_color == "black")
      # Check for pawns
      unless (@board[king_position[0] + 1][king_position[1] - 1].nil?)
        # Left pawn
        if (@board[king_position[0] + 1][king_position[1] - 1].type == "P" && @board[king_position[0] + 1][king_position[1] - 1].color == "white")
          return true
        end
      end
      # Right pawn
      unless (@board[king_position[0] + 1][king_position[1] + 1].nil?)
        if (@board[king_position[0] + 1][king_position[1] + 1].type == "P" && @board[king_position[0] + 1][king_position[1] + 1].color == "white")
          return true
        end
      end

      # Check for knights
      # Knight located up 2, left 1
      if (king_position[0] > 1 && king_position[1] > 0)
        unless (@board[king_position[0] - 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] - 1].type == "N" && @board[king_position[0] - 2][king_position[1] - 1].color == "white")
            return true
          end
        end
      end
      # Knight located up 2, right 1
      if (king_position[0] > 1 && king_position[1] < 7)
        unless (@board[king_position[0] - 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] + 1].type == "N" && @board[king_position[0] - 2][king_position[1] - 1].color == "white")
            return true
          end
        end
      end
      # Knight located left 2, up 1
      if (king_position[0] > 0 && king_position[1] > 1)
        unless (@board[king_position[0] - 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] - 2].type == "N" && @board[king_position[0] - 1][king_position[1] - 2].color == "white")
            return true
          end
        end
      end
      # Knight located left 2, down 1
      if (king_position[0] < 7 && king_position[1] > 1)
        unless (@board[king_position[0] + 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] - 2].type == "N" && @board[king_position[0] + 1][king_position[1] - 2].color == "white")
            return true
          end
        end
      end
      # Knight located right 2, up 1
      if (king_position[0] > 0 && king_position[1] < 6)
        unless (@board[king_position[0] - 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] + 2].type == "N" && @board[king_position[0] - 1][king_position[1] + 2].color == "white")
            return true
          end
        end
      end
      # Knight located right 2, down 1
      if (king_position[0] < 7 && king_position[1] < 6)
        unless (@board[king_position[0] + 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] + 2].type == "N" && @board[king_position[0] + 1][king_position[1] + 2].color == "white")
            return true
          end
        end
      end
      # Knight located down 2, left 1
      if (king_position[0] < 6 && king_position[1] > 0)
        unless (@board[king_position[0] + 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] + 2][king_position[1] - 1].type == "N" && @board[king_position[0] + 2][king_position[1] - 1].color == "white")
            return true
          end
        end
      end
      # Knight located down 2, right 1
      if (king_position[0] < 6 && king_position[1] < 7)
        unless (@board[king_position[0] + 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] + 2][king_position[1] + 1].type == "N" && @board[king_position[0] + 2][king_position[1] + 1].color == "white")
            return true
          end
        end
      end

      # Check for rooks and queens
      check = 0
      # All moves going up
      check = king_position[0]
      while (check > 0)
        until (@board[check - 1][king_position[1]].nil?)
          if (@board[check - 1][king_position[1]].type == "R" && @board[check - 1][king_position[1]].color == "white")
            return true
          elsif (@board[check - 1][king_position[1]].type == "Q" && @board[check - 1][king_position[1]].color == "white")
            return true
          end
          break
        end
        check -= 1
      end
      # All moves going down
      check = king_position[0]
      while (check < 7)
        until (@board[check + 1][king_position[1]].nil?)
          if (@board[check + 1][king_position[1]].type == "R" && @board[check + 1][king_position[1]].color == "white")
            return true
          elsif (@board[check + 1][king_position[1]].type == "Q" && @board[check + 1][king_position[1]].color == "white")
            return true
          end
          break
        end
        check += 1
      end
      # All moves going left
      check = king_position[1]
      while (check > 0)
        until (@board[king_position[0]][check - 1].nil?)
          if (@board[king_position[0]][check - 1].type == "R" && @board[king_position[0]][check - 1].color == "white")
            return true
          elsif (@board[king_position[0]][check - 1].type == "Q" && @board[king_position[0]][check - 1].color == "white")
            return true
          end
          break
        end
        check -= 1
      end
      # All moves going right
      check = king_position[1]
      while (check < 7)
        until (@board[king_position[0]][check + 1].nil?)
          if (@board[king_position[0]][check + 1].type == "R" && @board[king_position[0]][check + 1].color == "white")
            return true
          elsif (@board[king_position[0]][check + 1].type == "Q" && @board[king_position[0]][check + 1].color == "white")
            return true
          end
          break
        end
        check += 1
      end

      # Check for bishops and queens
      # All moves going up left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] > 0)
        until (@board[check[0] - 1][check[1] - 1].nil?)
          if (@board[check[0] - 1][check[1] - 1].type == "B" && @board[check[0] - 1][check[1] - 1].color == "white")
            return true
          elsif (@board[check[0] - 1][check[1] - 1].type == "Q" && @board[check[0] - 1][check[1] - 1].color == "white")
            return true
          end
          break
        end
        check[0] -= 1
        check[1] -= 1
      end
      # All moves going up right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] < 7)
        until (@board[check[0] - 1][check[1] + 1].nil?)
          if (@board[check[0] - 1][check[1] + 1].type == "B" && @board[check[0] - 1][check[1] + 1].color == "white")
            return true
          elsif (@board[check[0] - 1][check[1] + 1].type == "Q" && @board[check[0] - 1][check[1] + 1].color == "white")
            return true
          end
          break
        end
        check[0] -= 1
        check[1] += 1
      end
      # All moves going down left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] > 0)
        until (@board[check[0] + 1][check[1] - 1].nil?)
          if (@board[check[0] + 1][check[1] - 1].type == "B" && @board[check[0] + 1][check[1] - 1].color == "white")
            return true
          elsif (@board[check[0] + 1][check[1] - 1].type == "Q" && @board[check[0] + 1][check[1] - 1].color == "white")
            return true
          end
          break
        end
        check[0] += 1
        check[1] -= 1
      end
      # All moves going down right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] < 7)
        until (@board[check[0] + 1][check[1] + 1].nil?)
          if (@board[check[0] + 1][check[1] + 1].type == "B" && @board[check[0] + 1][check[1] + 1].color == "white")
            return true
          elsif (@board[check[0] + 1][check[1] + 1].type == "Q" && @board[check[0] + 1][check[1] + 1].color == "white")
            return true
          end
          break
        end
        check[0] += 1
        check[1] += 1
      end
    end

    false
  end

  def checkmate?
  end

end