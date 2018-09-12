class Board

	attr_reader :board

  def initialize
    @board = []
  end

  def create_board
  	8.times do
  		@board.push([nil, nil, nil, nil, nil, nil, nil, nil])
  	end
  end

  def add_pieces
  	@board.add_kings
  	@board.add_queens
  	@board.add_bishops
  	@board.add_knights
  	@board.add_rooks
  	@board.add_pawns
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

  def move_piece
  end

  def valid_move?
  	# Going need to call a number of methods available for checking the different pieces
  end

  def check?
  end

  def checkmate?
  end

end