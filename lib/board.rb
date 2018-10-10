require_relative "piece"

class Board

  attr_reader :board

  def initialize
    @board = []
  end

  # Board setup

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

  # Board movements

  def move_piece(start, finish, turn_color, turn_count, castling_used, in_check)

    # Invalid start piece movement
    if (@board[start[0]][start[1]].nil?)
      return "Invalid piece movement, try again."
    end

    # Invalid starting piece color
    if (@board[start[0]][start[1]].color != turn_color) 
      return "Invalid piece movement, try again."
    end

    # Move if we're not in check
    if (in_check == false)

      # Check if the move is valid and then move pieces
      if (valid_move?(start, finish, turn_color))
        @board[finish[0]][finish[1]] = @board[start[0]][start[1]]
        @board[start[0]][start[1]] = nil
        return "Piece moved."
      end

      # Logic for calling the en passant and castling methods
      if (@board[start[0]][start[1]].type == "P")
        en_passant_move = en_passant(start, finish, turn_color, turn_count)
        return en_passant_move if en_passant_move != "Invalid piece movement, try again."
      elsif (@board[start[0]][start[1]].type == "K")
        castling_move = castling(start, finish, turn_color, castling_used)
        return castling_move if castling_move != "Invalid piece movement, try again."
      end

      "Invalid piece movement, try again."
    # Move if we are in check
    elsif (in_check == true)
      start_piece = @board[start[0]][start[1]]
      finish_piece = @board[finish[0]][finish[1]]

      if (turn_color == "white")
        if (valid_move?(start, finish, turn_color))
          @board[finish[0]][finish[1]] = @board[start[0]][start[1]]
          @board[start[0]][start[1]] = nil
          if (check?(find_king(turn_color), turn_color))
            @board[start[0]][start[1]] = start_piece
            @board[finish[0]][finish[1]] = finish_piece
          else
            return "Piece moved, you are no longer in check."
          end
        else
          # Special case of en passant to ensure that it removes the attacking piece causing check
          if (@board[start[0]][start[1]].type == "P" && @board[finish[0]][finish[1]].nil? && start[1] != finish[1])
            if (finish[0] == start[0] - 1 && !(@board[finish[0] + 1][finish[1]].nil?))
              if (@board[finish[0] + 1][finish[1]].type == "P")
                finish_piece = @board[finish[0] - 1][finish[1]]
                if (en_passant(start, finish, turn_color, turn_count) == "En passant performed.")
                  if (check?(find_king(turn_color), turn_color))
                    @board[start[0]][start[1]] = start_piece
                    @board[finish[0]][finish[1]] = nil
                    @board[finish[0] + 1][finish[1]] = finish_piece
                  else
                    return "En passant performed, you are no longer in check."
                  end
                end
              end
            end
          end
        end
      elsif (turn_color == "black")
        if (valid_move?(start, finish, turn_color))
          @board[finish[0]][finish[1]] = @board[start[0]][start[1]]
          @board[start[0]][start[1]] = nil
          if (check?(find_king(turn_color), turn_color))
            @board[start[0]][start[1]] = start_piece
            @board[finish[0]][finish[1]] = finish_piece
          else
            return "Piece moved, you are no longer in check."
          end
        else
           # Special case of en passant to ensure that it removes the attacking piece causing check
          if (@board[start[0]][start[1]].type == "P" && @board[finish[0]][finish[1]].nil? && start[1] != finish[1])
            if (finish[0] == start[0] + 1 && !(@board[finish[0] - 1][finish[1]].nil?))
              if (@board[finish[0] - 1][finish[1]].type == "P")
                finish_piece = @board[finish[0] + 1][finish[1]]
                if (en_passant(start, finish, turn_color, turn_count) == "En passant performed.")
                  if (check?(find_king(turn_color), turn_color))
                    @board[start[0]][start[1]] = start_piece
                    @board[finish[0]][finish[1]] = nil
                    @board[finish[0] - 1][finish[1]] = finish_piece
                  else
                    return "En passant performed, you are no longer in check."
                  end
                end
              end
            end
          end
        end
      end

      "Invalid piece movement, you are still in check."
    end
  end

  def update_piece(update_position, turn_count)
    @board[update_position[0]][update_position[1]].last_moved = turn_count
    @board[update_position[0]][update_position[1]].times_moved += 1
    "Piece updated."
  end

  def castling(king_start, king_finish, turn_color, castling_used)
    # You can only use castling once per game
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
              # Check castling requirements
              if (@board[7][0].type == "R" && @board[7][0].last_moved == 0)
                # Ensure the king positions being moved do not result in check
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
              # Check castling requirements
              if (@board[0][7].type == "R" && @board[0][7].last_moved == 0)
                # Ensure the king positions being moved do not result in check
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
    # Use include here to make sure our finish position is among the available valid moves for that piece
    if (piece_type == "K")
      return valid_king(start, turn_color).include?(finish)
    elsif (piece_type == "Q")
      return valid_queen(start, turn_color).include?(finish)
    elsif (piece_type == "B")
      return valid_bishop(start, turn_color).include?(finish)
    elsif (piece_type == "R")
      return valid_rook(start, turn_color).include?(finish)
    elsif (piece_type == "N")
      return valid_knight(start, turn_color).include?(finish)
    elsif (piece_type == "P")
      return valid_pawn(start, turn_color).include?(finish)
    end
  end

  def valid_king(start, turn_color)
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

    # Check here for removing moves that place you in check
    moves_causing_check = []

    moves.each do |move|
      if (check?(move, turn_color))
        moves_causing_check.push(move)
      end
    end

    moves_causing_check.each do |remove|
      moves.delete(remove)
    end

    # Check here for moves overlapping with the enemy king and remove them

    enemy_color = "black" if turn_color == "white"
    enemy_color = "white" if turn_color == "black"

    enemy_king_moves = all_king_moves(enemy_color)

    enemy_king_moves.each do |enemy_king_move|
      moves.delete(enemy_king_move)
    end

    moves
  end

  def valid_queen(start, turn_color)
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

    return moves
  end

  def valid_bishop(start, turn_color)
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

    return moves
  end

  def valid_rook(start, turn_color)
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

    return moves
  end

  def valid_knight(start, turn_color)
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

    return moves
  end

  def valid_pawn(start, turn_color)
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

    return moves
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
    # Mimic the movements of a queen in reverse essentially, going outwards to find specific pieces that threaten the king

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
          if (@board[king_position[0] - 2][king_position[1] + 1].type == "N" && @board[king_position[0] - 2][king_position[1] + 1].color == "black")
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
        unless (@board[check - 1][king_position[1]].nil?)
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
        unless (@board[check + 1][king_position[1]].nil?)
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
        unless (@board[king_position[0]][check - 1].nil?)
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
        unless (@board[king_position[0]][check + 1].nil?)
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
        unless (@board[check[0] - 1][check[1] - 1].nil?)
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
        unless (@board[check[0] - 1][check[1] + 1].nil?)
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
        unless (@board[check[0] + 1][check[1] - 1].nil?)
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
        unless (@board[check[0] + 1][check[1] + 1].nil?)
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
          if (@board[king_position[0] - 2][king_position[1] + 1].type == "N" && @board[king_position[0] - 2][king_position[1] + 1].color == "white")
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
        unless (@board[check - 1][king_position[1]].nil?)
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
        unless (@board[check + 1][king_position[1]].nil?)
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
        unless (@board[king_position[0]][check - 1].nil?)
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
        unless (@board[king_position[0]][check + 1].nil?)
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
        unless (@board[check[0] - 1][check[1] - 1].nil?)
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
        unless (@board[check[0] - 1][check[1] + 1].nil?)
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
        unless (@board[check[0] + 1][check[1] - 1].nil?)
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
        unless (@board[check[0] + 1][check[1] + 1].nil?)
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

  def checkmate?(turn_color)
    # Checkmate is called assuming check? is already true

    king_position = find_king(turn_color)
    enemy_color = "black" if turn_color == "white"
    enemy_color = "white" if turn_color == "black"

    # Make sure the king cannot move
    return false unless valid_king(king_position, turn_color).empty?

    # Gather the attacking pieces
    # Check to see if they can be captured to remove the check
    attacking_pieces = find_attackers(king_position, turn_color)
    attacking_pieces.each do |location|
      return false if check?(location, enemy_color)
    end

    # Find attacker paths and for each board position check if it is the color of the player in check
    # Then check if each piece found has a valid move that can block, if not we're in checkmate
    blocks = possible_blocks(king_position, turn_color)
    8.times do |row|
      8.times do |col|
        unless (@board[row][col].nil?)
          if (@board[row][col].color == turn_color)
            blocks.each do |possible_block|
              return false if valid_move?([row, col], possible_block, turn_color)
            end
          end
        end
      end
    end

    true
  end

  def find_attackers(king_position, turn_color)

  # This method is a variant of check? that finds attacking paths for queens, bishops, and rooks
  # Instead of returning true/false, it gathers the attacking piece coordinates in an array and returns them

    attackers = []

    # White king
    if (turn_color == "white")
      # Check for pawns
      unless (@board[king_position[0] - 1][king_position[1] - 1].nil?)
        # Left pawn
        if (@board[king_position[0] - 1][king_position[1] - 1].type == "P" && @board[king_position[0] - 1][king_position[1] - 1].color == "black")
          attackers.push([king_position[0] - 1, king_position[1] - 1])
        end
      end
      unless (@board[king_position[0] - 1][king_position[1] + 1].nil?)
        # Right pawn
        if (@board[king_position[0] - 1][king_position[1] + 1].type == "P" && @board[king_position[0] - 1][king_position[1] + 1].color == "black")
          attackers.push([king_position[0] - 1, king_position[1] + 1])
        end
      end

      # Check for knights
      # Knight located up 2, left 1
      if (king_position[0] > 1 && king_position[1] > 0)
        unless (@board[king_position[0] - 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] - 1].type == "N" && @board[king_position[0] - 2][king_position[1] - 1].color == "black")
            attackers.push([king_position[0] - 2, king_position[1] - 1])
          end
        end
      end
      # Knight located up 2, right 1
      if (king_position[0] > 1 && king_position[1] < 7)
        unless (@board[king_position[0] - 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] + 1].type == "N" && @board[king_position[0] - 2][king_position[1] + 1].color == "black")
            attackers.push([king_position[0] - 2, king_position[1] + 1])
          end
        end
      end
      # Knight located left 2, up 1
      if (king_position[0] > 0 && king_position[1] > 1)
        unless (@board[king_position[0] - 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] - 2].type == "N" && @board[king_position[0] - 1][king_position[1] - 2].color == "black")
            attackers.push([king_position[0] - 1, king_position[1] - 2])
          end
        end
      end
      # Knight located left 2, down 1
      if (king_position[0] < 7 && king_position[1] > 1)
        unless (@board[king_position[0] + 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] - 2].type == "N" && @board[king_position[0] + 1][king_position[1] - 2].color == "black")
            attackers.push([king_position[0] + 1, king_position[1] - 2])
          end
        end
      end
      # Knight located right 2, up 1
      if (king_position[0] > 0 && king_position[1] < 6)
        unless (@board[king_position[0] - 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] + 2].type == "N" && @board[king_position[0] - 1][king_position[1] + 2].color == "black")
            attackers.push([king_position[0] - 1, king_position[1] + 2])
          end
        end
      end
      # Knight located right 2, down 1
      if (king_position[0] < 7 && king_position[1] < 6)
        unless (@board[king_position[0] + 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] + 2].type == "N" && @board[king_position[0] + 1][king_position[1] + 2].color == "black")
            attackers.push([king_position[0] + 1, king_position[1] + 2])
          end
        end
      end
      # Knight located down 2, left 1
      if (king_position[0] < 6 && king_position[1] > 0)
        unless (@board[king_position[0] + 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] + 2][king_position[1] - 1].type == "N" && @board[king_position[0] + 2][king_position[1] - 1].color == "black")
            attackers.push([king_position[0] + 2, king_position[1] - 1])
          end
        end
      end
      # Knight located down 2, right 1
      if (king_position[0] < 6 && king_position[1] < 7)
        unless (@board[king_position[0] + 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] + 2][king_position[1] + 1].type == "N" && @board[king_position[0] + 2][king_position[1] + 1].color == "black")
            attackers.push([king_position[0] + 2, king_position[1] + 1])
          end
        end
      end

      # Check for rooks and queens
      check = 0
      # All moves going up
      check = king_position[0]
      while (check > 0)
        unless (@board[check - 1][king_position[1]].nil?)
          if (@board[check - 1][king_position[1]].type == "R" && @board[check - 1][king_position[1]].color == "black")
            attackers.push([check - 1, king_position[1]])
          elsif (@board[check - 1][king_position[1]].type == "Q" && @board[check - 1][king_position[1]].color == "black")
            attackers.push([check - 1, king_position[1]])
          end
          break
        end
        check -= 1
      end
      # All moves going down
      check = king_position[0]
      while (check < 7)
        unless (@board[check + 1][king_position[1]].nil?)
          if (@board[check + 1][king_position[1]].type == "R" && @board[check + 1][king_position[1]].color == "black")
            attackers.push([check + 1, king_position[1]])
          elsif (@board[check + 1][king_position[1]].type == "Q" && @board[check + 1][king_position[1]].color == "black")
            attackers.push([check + 1, king_position[1]])
          end
          break
        end
        check += 1
      end
      # All moves going left
      check = king_position[1]
      while (check > 0)
        unless (@board[king_position[0]][check - 1].nil?)
          if (@board[king_position[0]][check - 1].type == "R" && @board[king_position[0]][check - 1].color == "black")
            attackers.push([king_position[0], check - 1])
          elsif (@board[king_position[0]][check - 1].type == "Q" && @board[king_position[0]][check - 1].color == "black")
            attackers.push([king_position[0], check - 1])
          end
          break
        end
        check -= 1
      end
      # All moves going right
      check = king_position[1]
      while (check < 7)
        unless (@board[king_position[0]][check + 1].nil?)
          if (@board[king_position[0]][check + 1].type == "R" && @board[king_position[0]][check + 1].color == "black")
            attackers.push([king_position[0], check + 1])
          elsif (@board[king_position[0]][check + 1].type == "Q" && @board[king_position[0]][check + 1].color == "black")
            attackers.push([king_position[0], check + 1])
          end
          break
        end
        check += 1
      end

      # Check for bishops and queens
      # All moves going up left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] > 0)
        unless (@board[check[0] - 1][check[1] - 1].nil?)
          if (@board[check[0] - 1][check[1] - 1].type == "B" && @board[check[0] - 1][check[1] - 1].color == "black")
            attackers.push([check[0] - 1, check[1] - 1])
          elsif (@board[check[0] - 1][check[1] - 1].type == "Q" && @board[check[0] - 1][check[1] - 1].color == "black")
            attackers.push([check[0] - 1, check[1] - 1])
          end
          break
        end
        check[0] -= 1
        check[1] -= 1
      end
      # All moves going up right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] < 7)
        unless (@board[check[0] - 1][check[1] + 1].nil?)
          if (@board[check[0] - 1][check[1] + 1].type == "B" && @board[check[0] - 1][check[1] + 1].color == "black")
            attackers.push([check[0] - 1, check[1] + 1])
          elsif (@board[check[0] - 1][check[1] + 1].type == "Q" && @board[check[0] - 1][check[1] + 1].color == "black")
            attackers.push([check[0] - 1, check[1] + 1])
          end
          break
        end
        check[0] -= 1
        check[1] += 1
      end
      # All moves going down left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] > 0)
        unless (@board[check[0] + 1][check[1] - 1].nil?)
          if (@board[check[0] + 1][check[1] - 1].type == "B" && @board[check[0] + 1][check[1] - 1].color == "black")
            attackers.push([check[0] + 1, check[1] - 1])
          elsif (@board[check[0] + 1][check[1] - 1].type == "Q" && @board[check[0] + 1][check[1] - 1].color == "black")
            attackers.push([check[0] + 1, check[1] - 1])
          end
          break
        end
        check[0] += 1
        check[1] -= 1
      end
      # All moves going down right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] < 7)
        unless (@board[check[0] + 1][check[1] + 1].nil?)
          if (@board[check[0] + 1][check[1] + 1].type == "B" && @board[check[0] + 1][check[1] + 1].color == "black")
            attackers.push([check[0] + 1, check[1] + 1])
          elsif (@board[check[0] + 1][check[1] + 1].type == "Q" && @board[check[0] + 1][check[1] + 1].color == "black")
            attackers.push([check[0] + 1, check[1] + 1])
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
          attackers.push([king_position[0] + 1, king_position[1] - 1])
        end
      end
      # Right pawn
      unless (@board[king_position[0] + 1][king_position[1] + 1].nil?)
        if (@board[king_position[0] + 1][king_position[1] + 1].type == "P" && @board[king_position[0] + 1][king_position[1] + 1].color == "white")
          attackers.push([king_position[0] + 1, king_position[1] + 1])
        end
      end

      # Check for knights
      # Knight located up 2, left 1
      if (king_position[0] > 1 && king_position[1] > 0)
        unless (@board[king_position[0] - 2][king_position[1] - 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] - 1].type == "N" && @board[king_position[0] - 2][king_position[1] - 1].color == "white")
            attackers.push([king_position[0] - 2, king_position[1] - 1])
          end
        end
      end
      # Knight located up 2, right 1
      if (king_position[0] > 1 && king_position[1] < 7)
        unless (@board[king_position[0] - 2][king_position[1] + 1].nil?)
          if (@board[king_position[0] - 2][king_position[1] + 1].type == "N" && @board[king_position[0] - 2][king_position[1] + 1].color == "white")
            attackers.push([king_position[0] - 2, king_position[1] + 1])
          end
        end
      end
      # Knight located left 2, up 1
      if (king_position[0] > 0 && king_position[1] > 1)
        unless (@board[king_position[0] - 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] - 2].type == "N" && @board[king_position[0] - 1][king_position[1] - 2].color == "white")
            attackers.push([king_position[0] - 1, king_position[1] - 2])
          end
        end
      end
      # Knight located left 2, down 1
      if (king_position[0] < 7 && king_position[1] > 1)
        unless (@board[king_position[0] + 1][king_position[1] - 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] - 2].type == "N" && @board[king_position[0] + 1][king_position[1] - 2].color == "white")
            attackers.push([king_position[0] + 1, king_position[1] - 2])
          end
        end
      end
      # Knight located right 2, up 1
      if (king_position[0] > 0 && king_position[1] < 6)
        unless (@board[king_position[0] - 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] - 1][king_position[1] + 2].type == "N" && @board[king_position[0] - 1][king_position[1] + 2].color == "white")
            attackers.push([king_position[0] - 1, king_position[1] + 2])
          end
        end
      end
      # Knight located right 2, down 1
      if (king_position[0] < 7 && king_position[1] < 6)
        unless (@board[king_position[0] + 1][king_position[1] + 2].nil?)
          if (@board[king_position[0] + 1][king_position[1] + 2].type == "N" && @board[king_position[0] + 1][king_position[1] + 2].color == "white")
            attackers.push([king_position[0] + 2, king_position[1] + 1])
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
        unless (@board[check - 1][king_position[1]].nil?)
          if (@board[check - 1][king_position[1]].type == "R" && @board[check - 1][king_position[1]].color == "white")
            attackers.push([check - 1, king_position[1]])
          elsif (@board[check - 1][king_position[1]].type == "Q" && @board[check - 1][king_position[1]].color == "white")
            attackers.push([check - 1, king_position[1]])
          end
          break
        end
        check -= 1
      end
      # All moves going down
      check = king_position[0]
      while (check < 7)
        unless (@board[check + 1][king_position[1]].nil?)
          if (@board[check + 1][king_position[1]].type == "R" && @board[check + 1][king_position[1]].color == "white")
            attackers.push([check + 1, king_position[1]])
          elsif (@board[check + 1][king_position[1]].type == "Q" && @board[check + 1][king_position[1]].color == "white")
            attackers.push([check + 1, king_position[1]])
          end
          break
        end
        check += 1
      end
      # All moves going left
      check = king_position[1]
      while (check > 0)
        unless (@board[king_position[0]][check - 1].nil?)
          if (@board[king_position[0]][check - 1].type == "R" && @board[king_position[0]][check - 1].color == "white")
            attackers.push([king_position[0], check - 1])
          elsif (@board[king_position[0]][check - 1].type == "Q" && @board[king_position[0]][check - 1].color == "white")
            attackers.push([king_position[0], check - 1])
          end
          break
        end
        check -= 1
      end
      # All moves going right
      check = king_position[1]
      while (check < 7)
        unless (@board[king_position[0]][check + 1].nil?)
          if (@board[king_position[0]][check + 1].type == "R" && @board[king_position[0]][check + 1].color == "white")
            attackers.push([king_position[0], check + 1])
          elsif (@board[king_position[0]][check + 1].type == "Q" && @board[king_position[0]][check + 1].color == "white")
            attackers.push([king_position[0], check + 1])
          end
          break
        end
        check += 1
      end

      # Check for bishops and queens
      # All moves going up left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] > 0)
        unless (@board[check[0] - 1][check[1] - 1].nil?)
          if (@board[check[0] - 1][check[1] - 1].type == "B" && @board[check[0] - 1][check[1] - 1].color == "white")
            attackers.push([check[0] - 1, check[1] - 1])
          elsif (@board[check[0] - 1][check[1] - 1].type == "Q" && @board[check[0] - 1][check[1] - 1].color == "white")
            attackers.push([check[0] - 1, check[1] - 1])
          end
          break
        end
        check[0] -= 1
        check[1] -= 1
      end
      # All moves going up right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] < 7)
        unless (@board[check[0] - 1][check[1] + 1].nil?)
          if (@board[check[0] - 1][check[1] + 1].type == "B" && @board[check[0] - 1][check[1] + 1].color == "white")
            attackers.push([check[0] - 1, check[1] + 1])
          elsif (@board[check[0] - 1][check[1] + 1].type == "Q" && @board[check[0] - 1][check[1] + 1].color == "white")
            attackers.push([check[0] - 1, check[1] + 1])
          end
          break
        end
        check[0] -= 1
        check[1] += 1
      end
      # All moves going down left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] > 0)
        unless (@board[check[0] + 1][check[1] - 1].nil?)
          if (@board[check[0] + 1][check[1] - 1].type == "B" && @board[check[0] + 1][check[1] - 1].color == "white")
            attackers.push([check[0] + 1, check[1] - 1])
          elsif (@board[check[0] + 1][check[1] - 1].type == "Q" && @board[check[0] + 1][check[1] - 1].color == "white")
            attackers.push([check[0] + 1, check[1] - 1])
          end
          break
        end
        check[0] += 1
        check[1] -= 1
      end
      # All moves going down right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] < 7)
        unless (@board[check[0] + 1][check[1] + 1].nil?)
          if (@board[check[0] + 1][check[1] + 1].type == "B" && @board[check[0] + 1][check[1] + 1].color == "white")
            attackers.push([check[0] + 1, check[1] + 1])
          elsif (@board[check[0] + 1][check[1] + 1].type == "Q" && @board[check[0] + 1][check[1] + 1].color == "white")
            attackers.push([check[0] + 1, check[1] + 1])
          end
          break
        end
        check[0] += 1
        check[1] += 1
      end
    end

    attackers
  end

  def possible_blocks(king_position, turn_color)

    # This method is a variant of both check? and find_attackers
    # It locates the potential positions that can be blocked for the rook, bishop, and queen pieces in check
    # The array returned includes all blockable positions excluding those the king and attacking piece are in

    block_positions = []

    # White king
    if (turn_color == "white")
      # Check for rooks and queens
      check = 0
      # All moves going up
      check = king_position[0]
      while (check > 0)
        unless (@board[check - 1][king_position[1]].nil?)
          if (@board[check - 1][king_position[1]].type == "R" && @board[check - 1][king_position[1]].color == "black")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse += 1
            end
          elsif (@board[check - 1][king_position[1]].type == "Q" && @board[check - 1][king_position[1]].color == "black")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse += 1
            end
          end
          break
        end
        check -= 1
      end
      # All moves going down
      check = king_position[0]
      while (check < 7)
        unless (@board[check + 1][king_position[1]].nil?)
          if (@board[check + 1][king_position[1]].type == "R" && @board[check + 1][king_position[1]].color == "black")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse -= 1
            end
          elsif (@board[check + 1][king_position[1]].type == "Q" && @board[check + 1][king_position[1]].color == "black")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse -= 1
            end
          end
          break
        end
        check += 1
      end
      # All moves going left
      check = king_position[1]
      while (check > 0)
        unless (@board[king_position[0]][check - 1].nil?)
          if (@board[king_position[0]][check - 1].type == "R" && @board[king_position[0]][check - 1].color == "black")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse += 1
            end
          elsif (@board[king_position[0]][check - 1].type == "Q" && @board[king_position[0]][check - 1].color == "black")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse += 1
            end
          end
          break
        end
        check -= 1
      end
      # All moves going right
      check = king_position[1]
      while (check < 7)
        unless (@board[king_position[0]][check + 1].nil?)
          if (@board[king_position[0]][check + 1].type == "R" && @board[king_position[0]][check + 1].color == "black")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse -= 1
            end
          elsif (@board[king_position[0]][check + 1].type == "Q" && @board[king_position[0]][check + 1].color == "black")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse -= 1
            end
          end
          break
        end
        check += 1
      end

      # Check for bishops and queens
      # All moves going up left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] > 0)
        unless (@board[check[0] - 1][check[1] - 1].nil?)
          if (@board[check[0] - 1][check[1] - 1].type == "B" && @board[check[0] - 1][check[1] - 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] += 1
            end
          elsif (@board[check[0] - 1][check[1] - 1].type == "Q" && @board[check[0] - 1][check[1] - 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] += 1
            end
          end
          break
        end
        check[0] -= 1
        check[1] -= 1
      end
      # All moves going up right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] < 7)
        unless (@board[check[0] - 1][check[1] + 1].nil?)
          if (@board[check[0] - 1][check[1] + 1].type == "B" && @board[check[0] - 1][check[1] + 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] -= 1
            end
          elsif (@board[check[0] - 1][check[1] + 1].type == "Q" && @board[check[0] - 1][check[1] + 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] -= 1
            end
          end
          break
        end
        check[0] -= 1
        check[1] += 1
      end
      # All moves going down left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] > 0)
        unless (@board[check[0] + 1][check[1] - 1].nil?)
          if (@board[check[0] + 1][check[1] - 1].type == "B" && @board[check[0] + 1][check[1] - 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] += 1
            end
          elsif (@board[check[0] + 1][check[1] - 1].type == "Q" && @board[check[0] + 1][check[1] - 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] += 1
            end
          end
          break
        end
        check[0] += 1
        check[1] -= 1
      end
      # All moves going down right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] < 7)
        unless (@board[check[0] + 1][check[1] + 1].nil?)
          if (@board[check[0] + 1][check[1] + 1].type == "B" && @board[check[0] + 1][check[1] + 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] -= 1
            end
          elsif (@board[check[0] + 1][check[1] + 1].type == "Q" && @board[check[0] + 1][check[1] + 1].color == "black")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] -= 1
            end
          end
          break
        end
        check[0] += 1
        check[1] += 1
      end

    # Black king
    elsif (turn_color == "black")
      # Check for rooks and queens
      check = 0
      # All moves going up
      check = king_position[0]
      while (check > 0)
        unless (@board[check - 1][king_position[1]].nil?)
          if (@board[check - 1][king_position[1]].type == "R" && @board[check - 1][king_position[1]].color == "white")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse += 1
            end
          elsif (@board[check - 1][king_position[1]].type == "Q" && @board[check - 1][king_position[1]].color == "white")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse += 1
            end
          end
          break
        end
        check -= 1
      end
      # All moves going down
      check = king_position[0]
      while (check < 7)
        unless (@board[check + 1][king_position[1]].nil?)
          if (@board[check + 1][king_position[1]].type == "R" && @board[check + 1][king_position[1]].color == "white")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse -= 1
            end
          elsif (@board[check + 1][king_position[1]].type == "Q" && @board[check + 1][king_position[1]].color == "white")
            reverse = check
            until (reverse == king_position[0])
              block_positions.push([reverse, king_position[1]])
              reverse -= 1
            end
          end
          break
        end
        check += 1
      end
      # All moves going left
      check = king_position[1]
      while (check > 0)
        unless (@board[king_position[0]][check - 1].nil?)
          if (@board[king_position[0]][check - 1].type == "R" && @board[king_position[0]][check - 1].color == "white")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse += 1
            end
          elsif (@board[king_position[0]][check - 1].type == "Q" && @board[king_position[0]][check - 1].color == "white")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse += 1
            end
          end
          break
        end
        check -= 1
      end
      # All moves going right
      check = king_position[1]
      while (check < 7)
        unless (@board[king_position[0]][check + 1].nil?)
          if (@board[king_position[0]][check + 1].type == "R" && @board[king_position[0]][check + 1].color == "white")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse -= 1
            end
          elsif (@board[king_position[0]][check + 1].type == "Q" && @board[king_position[0]][check + 1].color == "white")
            reverse = check
            until (reverse == king_position[1])
              block_positions.push([king_position[0], reverse])
              reverse -= 1
            end
          end
          break
        end
        check += 1
      end

      # Check for bishops and queens
      # All moves going up left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] > 0)
        unless (@board[check[0] - 1][check[1] - 1].nil?)
          if (@board[check[0] - 1][check[1] - 1].type == "B" && @board[check[0] - 1][check[1] - 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] += 1
            end
          elsif (@board[check[0] - 1][check[1] - 1].type == "Q" && @board[check[0] - 1][check[1] - 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] += 1
            end
          end
          break
        end
        check[0] -= 1
        check[1] -= 1
      end
      # All moves going up right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] > 0 && check[1] < 7)
        unless (@board[check[0] - 1][check[1] + 1].nil?)
          if (@board[check[0] - 1][check[1] + 1].type == "B" && @board[check[0] - 1][check[1] + 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] -= 1
            end
          elsif (@board[check[0] - 1][check[1] + 1].type == "Q" && @board[check[0] - 1][check[1] + 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] += 1
              reverse[1] -= 1
            end
          end
          break
        end
        check[0] -= 1
        check[1] += 1
      end
      # All moves going down left diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] > 0)
        unless (@board[check[0] + 1][check[1] - 1].nil?)
          if (@board[check[0] + 1][check[1] - 1].type == "B" && @board[check[0] + 1][check[1] - 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] += 1
            end
          elsif (@board[check[0] + 1][check[1] - 1].type == "Q" && @board[check[0] + 1][check[1] - 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] += 1
            end
          end
          break
        end
        check[0] += 1
        check[1] -= 1
      end
      # All moves going down right diagonal
      check = [king_position[0], king_position[1]]
      while (check[0] < 7 && check[1] < 7)
        unless (@board[check[0] + 1][check[1] + 1].nil?)
          if (@board[check[0] + 1][check[1] + 1].type == "B" && @board[check[0] + 1][check[1] + 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] -= 1
            end
          elsif (@board[check[0] + 1][check[1] + 1].type == "Q" && @board[check[0] + 1][check[1] + 1].color == "white")
            reverse = check
            until (reverse == king_position)
              block_positions.push([reverse[0], reverse[1]])
              reverse[0] -= 1
              reverse[1] -= 1
            end
          end
          break
        end
        check[0] += 1
        check[1] += 1
      end
    end

    block_positions
  end

  def all_king_moves(piece_color)

    # A variant of valid_king that finds all possible movements of the king on the board, regardless of movement limitations
    # This is to be used for achieving checkmate, to prevent the kings from entering check on each other

    start = find_king(piece_color)

    king_moves = []

    # Move up
    if (start[0] > 0)
      king_moves.push([start[0] - 1, start[1]])

      # Move up and left
      if (start[1] > 0)
        king_moves.push([start[0] - 1, start[1] - 1])
      end

      # Move up and right
      if (start[1] < 7)
        king_moves.push([start[0] - 1, start[1] + 1])
      end
    end

    # Move down
    if (start[0] < 7)
      king_moves.push([start[0] + 1, start[1]])

      # Move up and left
      if (start[1] > 0)
        king_moves.push([start[0] + 1, start[1] - 1])
      end

      # Move up and right
      if (start[1] < 7)
        king_moves.push([start[0] + 1, start[1] + 1])
      end
    end

    # Move left
    if (start[1] > 0)
      king_moves.push([start[0], start[1] - 1])
    end

    # Move right
    if (start[1] < 7)
      king_moves.push([start[0], start[1] + 1])
    end
  end

end