require "board"

describe Board do

  before(:each) do
    @game_board = Board.new
  end

  describe "#create_board" do
    it "returns that the board is filled with nil values" do
      @game_board.create_board
      expect(@game_board.board[7][7]).to eql(nil)
    end
  end

  describe "#add_kings" do
    context "given an empty board" do
      it "returns the black king at its initial spot" do
        @game_board.create_board
        @game_board.add_kings
        expect(@game_board.board[0][4].type).to eql("K")
      end

      it "returns the white king at its initial spot" do
        @game_board.create_board
        @game_board.add_kings
        expect(@game_board.board[7][4].type).to eql("K")
      end
    end
  end

  describe "#add_queens" do
    context "given an empty board" do
      it "returns the black queen at its initial spot" do
        @game_board.create_board
        @game_board.add_queens
        expect(@game_board.board[0][3].type).to eql("Q")
      end

      it "returns the white queen at its initial spot" do
        @game_board.create_board
        @game_board.add_queens
        expect(@game_board.board[7][3].type).to eql("Q")
      end
    end
  end

  describe "#add_bishops" do
    context "given an empty board" do
      it "returns the left black bishop at its initial spot" do
        @game_board.create_board
        @game_board.add_bishops
        expect(@game_board.board[0][2].type).to eql("B")
      end

      it "returns the right black bishop at its initial spot" do
        @game_board.create_board
        @game_board.add_bishops
        expect(@game_board.board[0][5].type).to eql("B")
      end

      it "returns the left white bishop at its initial spot" do
        @game_board.create_board
        @game_board.add_bishops
        expect(@game_board.board[7][2].type).to eql("B")
      end

      it "returns the right white bishop at its initial spot" do
        @game_board.create_board
        @game_board.add_bishops
        expect(@game_board.board[7][5].type).to eql("B")
      end
    end
  end

  describe "#add_knights" do
    context "given an empty board" do
      it "returns the left black knight at its initial spot" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.board[0][1].type).to eql("N")
      end

      it "returns the right black knight at its initial spot" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.board[0][6].type).to eql("N")
      end

      it "returns the left white knight at its initial spot" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.board[7][1].type).to eql("N")
      end

      it "returns the right white knight at its initial spot" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.board[7][6].type).to eql("N")
      end
    end
  end

  describe "#add_rooks" do
    context "given an empty board" do
      it "returns the left black rook at its initial spot" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.board[0][0].type).to eql("R")
      end

      it "returns the right black rook at its initial spot" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.board[0][7].type).to eql("R")
      end

      it "returns the left white rook at its initial spot" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.board[7][0].type).to eql("R")
      end

      it "returns the right white rook at its initial spot" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.board[7][7].type).to eql("R")
      end
    end
  end

  describe "#add_pawns" do
    context "given an empty board" do
      it "returns the left most black pawn at its initial spot" do
        @game_board.create_board
        @game_board.add_pawns
        expect(@game_board.board[1][0].type).to eql("P")
      end

      it "returns the right most black pawn at its initial spot" do
        @game_board.create_board
        @game_board.add_pawns
        expect(@game_board.board[1][7].type).to eql("P")
      end

      it "returns the left most white pawn at its initial spot" do
        @game_board.create_board
        @game_board.add_pawns
        expect(@game_board.board[6][0].type).to eql("P")
      end

      it "returns the left most white pawn at its initial spot" do
        @game_board.create_board
        @game_board.add_pawns
        expect(@game_board.board[6][7].type).to eql("P")
      end
    end
  end

  describe "#valid_pawn" do
    context "given a starting board" do
      it "returns true moving the left most white pawn forward once" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.valid_pawn([6, 0], "white").include?([5, 0])).to eql(true)
      end

      it "returns true moving the left most white pawn forward twice from start" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.valid_pawn([6, 0], "white").include?([4, 0])).to eql(true)
      end
    end

    context "given a board where the second left white pawn can capture" do
      it "returns true when the left diagonal piece is capturable" do
        @game_board.create_board
        @game_board.add_pieces
        @game_board.move_piece([1, 0], [3, 0], "black", 1, false, false)
        @game_board.move_piece([3, 0], [4, 0], "black", 1, false, false)
        @game_board.move_piece([6, 1], [5, 1], "white", 1, false, false)
        expect(@game_board.valid_pawn([5, 1], "white").include?([4, 0])).to eql(true)
      end

      it "returns true when the right diagonal piece is capturable" do
        @game_board.create_board
        @game_board.add_pieces
        @game_board.move_piece([1, 2], [3, 2], "black", 1, false, false)
        @game_board.move_piece([3, 2], [4, 2], "black", 1, false, false)
        @game_board.move_piece([6, 1], [5, 1], "white", 1, false, false)
        expect(@game_board.valid_pawn([5, 1], "white").include?([4, 2])).to eql(true)
      end
    end
  end


  describe "#valid_knight" do
    context "given only knights moving the left white knight" do
      it "returns true moving a white knight at c3 up 2 and left 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([3, 1])).to eql(true)
      end

      it "returns true moving a white knight at c3 up 2 and right 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([3, 3])).to eql(true)
      end

      it "returns true moving a white knight at c3 left 2 and up 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([4, 0])).to eql(true)
      end

      it "returns true moving a white knight at c3 left 2 and down 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([6, 0])).to eql(true)
      end

      it "returns true moving a white knight at c3 right 2 and up 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([4, 4])).to eql(true)
      end

      it "returns true moving a white knight at c3 right 2 and down 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([6, 4])).to eql(true)
      end

      it "returns true moving a white knight at c3 down 2 and left 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([7, 1])).to eql(true)
      end

      it "returns true moving a white knight at c3 down 2 and right 1" do
        @game_board.create_board
        @game_board.add_knights
        @game_board.move_piece([7, 1], [5, 2], "white", 1, false, false)
        expect(@game_board.valid_knight([5, 2], "white").include?([7, 3])).to eql(true)
      end
    end

    context "given only knights in starting position" do
      it "returns false moving the left white knight down 2 and left 1" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.valid_knight([7, 1], "white").include?([9, 0])).to eql(false)
      end

      it "returns false moving the right white knight down 2 and right 1" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.valid_knight([7, 6], "white").include?([9, 7])).to eql(false)
      end

      it "returns false moving the left black knight up 2 and left 1" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.valid_knight([0, 1], "white").include?([-2, 0])).to eql(false)
      end

      it "returns false moving the right black knight up 2 and right 1" do
        @game_board.create_board
        @game_board.add_knights
        expect(@game_board.valid_knight([0, 6], "white").include?([-2, 7])).to eql(false)
      end
    end
  end

  describe "#valid_rook" do
    context "given only rooks moving the left white rook" do
      it "returns true moving a white rook at b2 to a2" do
        @game_board.create_board
        @game_board.add_rooks
        @game_board.move_piece([7, 0], [6, 0], "white", 1, false, false)
        @game_board.move_piece([6, 0], [6, 1], "white", 1, false, false)
        expect(@game_board.valid_rook([6, 1], "white").include?([6, 0])).to eql(true)
      end

      it "returns true moving a white rook at b2 to h2" do
        @game_board.create_board
        @game_board.add_rooks
        @game_board.move_piece([7, 0], [6, 0], "white", 1, false, false)
        @game_board.move_piece([6, 0], [6, 1], "white", 1, false, false)
        expect(@game_board.valid_rook([6, 1], "white").include?([6, 7])).to eql(true)
      end

      it "returns true moving a white rook at b2 to b1" do
        @game_board.create_board
        @game_board.add_rooks
        @game_board.move_piece([7, 0], [6, 0], "white", 1, false, false)
        @game_board.move_piece([6, 0], [6, 1], "white", 1, false, false)
        expect(@game_board.valid_rook([6, 1], "white").include?([7, 1])).to eql(true)
      end

      it "returns true moving a white rook at b2 to b8" do
        @game_board.create_board
        @game_board.add_rooks
        @game_board.move_piece([7, 0], [6, 0], "white", 1, false, false)
        @game_board.move_piece([6, 0], [6, 1], "white", 1, false, false)
        expect(@game_board.valid_rook([6, 1], "white").include?([0, 1])).to eql(true)
      end
    end

    context "given only rooks in starting position" do
      it "returns false moving a white rook at a1 to b2" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.valid_rook([7, 0], "white").include?([6, 1])).to eql(false)
      end

      it "returns false moving a white rook at h1 to g2" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.valid_rook([7, 7], "white").include?([6, 6])).to eql(false)
      end

      it "returns false moving a black rook at a8 off the board" do
        @game_board.create_board
        @game_board.add_rooks
        expect(@game_board.valid_rook([0, 0], "white").include?([0, -1])).to eql(false)
      end
    end
  end

  describe "#valid_bishop" do
    context "given only rooks" do
      it "returns true if you can move a white bishop at d4 to a1" do
        @game_board.create_board
        @game_board.add_bishops
        @game_board.move_piece([7, 2], [6, 3], "white", 1, false, false)
        @game_board.move_piece([6, 3], [5, 2], "white", 1, false, false)
        @game_board.move_piece([5, 2], [4, 3], "white", 1, false, false)
        expect(@game_board.valid_bishop([4, 3], "white").include?([7, 0])).to eql(true)
      end

      it "returns true moving a white bishop at g2 to h1" do
        @game_board.create_board
        @game_board.add_bishops
        @game_board.move_piece([7, 5], [6, 6], "white", 1, false, false)
        expect(@game_board.valid_bishop([6, 6], "white").include?([7, 7])).to eql(true)
      end

      it "returns true moving a black bishop at b7 to a8" do
        @game_board.create_board
        @game_board.add_bishops
        @game_board.move_piece([0, 2], [1, 1], "black", 1, false, false)
        expect(@game_board.valid_bishop([1, 1], "black").include?([0, 2])).to eql(true)
      end

      it "returns true moving a black bishop at g7 to h8" do
        @game_board.create_board
        @game_board.add_bishops
        @game_board.move_piece([0, 5], [1, 6], "black", 1, false, false)
        expect(@game_board.valid_bishop([1, 6], "black").include?([0, 7])).to eql(true)
      end
    end
  end

  describe "#valid_queen" do
    context "given only queens" do
      it "returns true moving the white queen at d1 (start) to be able to capture d8" do
        @game_board.create_board
        @game_board.add_queens
        expect(@game_board.valid_queen([7, 3], "white").include?([0, 3])).to eql(true)
      end

      it "returns true moving the white queen at d1 (start) to a1" do
        @game_board.create_board
        @game_board.add_queens
        expect(@game_board.valid_queen([7, 3], "white").include?([7, 0])).to eql(true)
      end

      it "returns true moving the white queen at d1 (start) to a4" do
        @game_board.create_board
        @game_board.add_queens
        expect(@game_board.valid_queen([7, 3], "white").include?([7, 7])).to eql(true)
      end

      it "returns true moving the white queen at d1 (start) to h5" do
        @game_board.create_board
        @game_board.add_queens
        expect(@game_board.valid_queen([7, 3], "white").include?([3, 7])).to eql(true)
      end
    end
  end
  
  describe "#valid_king" do
    context "given only kings" do
      it "returns true if the white king at e2 can move up to e3" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([5, 4])).to eql(true)
      end

      it "returns true if the white king at e2 can move up left to d3" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([5, 3])).to eql(true)
      end

      it "returns true if the white king at e2 can move up right to f3" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([5, 5])).to eql(true)
      end

      it "returns true if the white king at e2 can move down to e1" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([7, 4])).to eql(true)
      end

      it "returns true if the white king at e2 can move down left to d1" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([7, 3])).to eql(true)
      end

      it "returns true if the white king at e2 can move down right to f1" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([7, 5])).to eql(true)
      end

      it "returns true if the white king at e2 can move left to d2" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([6, 3])).to eql(true)
      end

      it "returns true if the white king at e2 can move right to f2" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        expect(@game_board.valid_king([6, 4], "white").include?([6, 5])).to eql(true)
      end
    end
  end

  describe "#update_piece" do
    context "given a starting board" do
      it "returns 'Piece updated.' when updating the left most white pawn" do
      @game_board.create_board
      @game_board.add_pieces
      expect(@game_board.update_piece([6, 0], 1)).to eql("Piece updated.")
      end
    end
  end

  describe "#find_promotion" do
    context "given a white pawn at h8" do
      it "returns an array with the coordinates of the white pawn" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 6], [4, 6], "white", 1, false, false)
        @game_board.move_piece([4, 6], [3, 6], "white", 1, false, false)
        @game_board.move_piece([3, 6], [2, 6], "white", 1, false, false)
        @game_board.move_piece([2, 6], [1, 7], "white", 1, false, false)
        @game_board.move_piece([1, 7], [0, 7], "white", 1, false, false)
        expect(@game_board.find_promotion).to eql([0, 7])
      end
    end

    context "given a starting board" do
      it "returns nil when there are no pawns for promotion" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.find_promotion).to eql(nil)
      end
    end
  end

  describe "#promote_pawn" do
    context "given a white pawn at h8" do
      it "returns Q when promoting the pawn to a queen" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 6], [4, 6], "white", 1, false, false)
        @game_board.move_piece([4, 6], [3, 6], "white", 1, false, false)
        @game_board.move_piece([3, 6], [2, 6], "white", 1, false, false)
        @game_board.move_piece([2, 6], [1, 7], "white", 1, false, false)
        @game_board.move_piece([1, 7], [0, 7], "white", 1, false, false)
        expect(@game_board.promote_pawn([0,7],"Q")).to eql("Q")
      end

      it "returns B when promoting the pawn to a bishop" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 6], [4, 6], "white", 1, false, false)
        @game_board.move_piece([4, 6], [3, 6], "white", 1, false, false)
        @game_board.move_piece([3, 6], [2, 6], "white", 1, false, false)
        @game_board.move_piece([2, 6], [1, 7], "white", 1, false, false)
        @game_board.move_piece([1, 7], [0, 7], "white", 1, false, false)
        expect(@game_board.promote_pawn([0,7],"B")).to eql("B")
      end

      it "returns R when promoting the pawn to a rook" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 6], [4, 6], "white", 1, false, false)
        @game_board.move_piece([4, 6], [3, 6], "white", 1, false, false)
        @game_board.move_piece([3, 6], [2, 6], "white", 1, false, false)
        @game_board.move_piece([2, 6], [1, 7], "white", 1, false, false)
        @game_board.move_piece([1, 7], [0, 7], "white", 1, false, false)
        expect(@game_board.promote_pawn([0,7],"R")).to eql("R")
      end

      it "returns N when promoting the pawn to a knight" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 6], [4, 6], "white", 1, false, false)
        @game_board.move_piece([4, 6], [3, 6], "white", 1, false, false)
        @game_board.move_piece([3, 6], [2, 6], "white", 1, false, false)
        @game_board.move_piece([2, 6], [1, 7], "white", 1, false, false)
        @game_board.move_piece([1, 7], [0, 7], "white", 1, false, false)
        expect(@game_board.promote_pawn([0,7],"N")).to eql("N")
      end
    end
  end

  describe "#find_king" do
    context "given a starting board" do
      it "returns the coords for e8 where the white king is" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.find_king("white")).to eql([7, 4])
      end

      it "returns the coords for e1 where the black king is" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.find_king("black")).to eql([0, 4])
      end
    end
  end

  describe "#check?" do
    context "given a starting board" do
      it "returns false where the white king is" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.check?([7, 4], "white")).to eql(false)
      end
    end

    context "given all pieces except pawns" do
      it "returns true when a black rook is threatening the white king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_knights
        @game_board.add_rooks
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 7], [1, 7], "black", 1, false, false)
        @game_board.move_piece([1, 7], [1, 4], "black", 1, false, false)
        expect(@game_board.check?([7, 4], "white")).to eql(true)
      end

      it "returns true when a black queen is threatening the white king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_knights
        @game_board.add_rooks
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 3], [1, 4], "black", 1, false, false)
        expect(@game_board.check?([7, 4], "white")).to eql(true)
      end

      it "returns true when a white bishop is threatening the black king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_knights
        @game_board.add_rooks
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 4], [1, 4], "black", 1, false, false)
        @game_board.move_piece([7, 2], [5, 0], "white", 1, false, false)
        expect(@game_board.check?([1, 4], "black")).to eql(true)
      end

      it "returns true when a white knight is threatening the black king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_knights
        @game_board.add_rooks
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 4], [1, 5], "black", 1, false, false)
        @game_board.move_piece([7, 6], [5, 5], "white", 1, false, false)
        @game_board.move_piece([5, 5], [3, 4], "white", 1, false, false)
        expect(@game_board.check?([1, 5], "black")).to eql(true)
      end
    end

    context "given only pawns and kings" do
      it "returns true when a white pawn is threatening the black king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_pawns
        @game_board.move_piece([6, 6], [4, 6], "white", 1, false, false)
        @game_board.move_piece([4, 6], [3, 6], "white", 1, false, false)
        @game_board.move_piece([3, 6], [2, 6], "white", 1, false, false)
        @game_board.move_piece([2, 6], [1, 5], "white", 1, false, false)
        expect(@game_board.check?([0, 4], "black")).to eql(true)
      end

      it "returns true when a black pawn is threatening the white king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_pawns
        @game_board.move_piece([1, 6], [3, 6], "black", 1, false, false)
        @game_board.move_piece([3, 6], [4, 6], "black", 1, false, false)
        @game_board.move_piece([4, 6], [5, 6], "black", 1, false, false)
        @game_board.move_piece([5, 6], [6, 5], "black", 1, false, false)
        expect(@game_board.check?([7, 4], "white")).to eql(true)
      end
    end
  end

  describe "#castling" do
    context "given only rooks and kings" do
      it "returns 'Castling performed.' after castling with the white king and right white rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        expect(@game_board.castling([7, 4], [7, 6], "white", false)).to eql("Castling performed.")
      end

      it "returns 'Castling performed.' after castling with the white king and left white rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        expect(@game_board.castling([7, 4], [7, 2], "white", false)).to eql("Castling performed.")
      end

      it "returns 'Castling performed.' after castling with the black king and right black rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        expect(@game_board.castling([0, 4], [0, 6], "black", false)).to eql("Castling performed.")
      end

      it "returns 'Castling performed.' after castling with the black king and left black rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        expect(@game_board.castling([0, 4], [0, 2], "black", false)).to eql("Castling performed.")
      end

      it "returns 'Invalid piece movement, try again.' after attempting castling when it has already been used" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        expect(@game_board.castling([7, 4], [7, 6], "white", true)).to eql("Invalid piece movement, try again.")
      end

      it "returns 'Invalid piece movement, try again.' after attempting castling with a moved rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.update_piece([7, 7], 2)
        expect(@game_board.castling([7, 4], [7, 6], "white", false)).to eql("Invalid piece movement, try again.")
      end

      it "returns 'Invalid piece movement, try again.' after attempting castling with a moved king" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.update_piece([7, 4], 2)
        expect(@game_board.castling([7, 4], [7, 6], "white", false)).to eql("Invalid piece movement, try again.")
      end
    end

    context "given only rooks, kings, and bishops" do
      it "returns 'Invalid piece movement, try again.' after attempting castling with pieces in the way" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.add_bishops
        expect(@game_board.castling([7, 4], [7, 6], "white", false)).to eql("Invalid piece movement, try again.")
      end
    end
  end

  describe "en_passant" do
    context "given only pawns" do
      it "returns 'En passant performed.' after performing en passant left using the pawn at b2" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([1, 0], [3, 0], "black", 3, false, false)
        @game_board.update_piece([3, 0], 3)
        expect(@game_board.en_passant([3, 1], [2, 0], "white", 4)).to eql("En passant performed.")
      end

      it "returns 'En passant performed.' after performing en passant right using the pawn at b2" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([1, 2], [3, 2], "black", 3, false, false)
        @game_board.update_piece([3, 2], 3)
        expect(@game_board.en_passant([3, 1], [2, 2], "white", 4)).to eql("En passant performed.")
      end

      it "returns 'En passant performed.' after performing en passant left using the pawn at b7" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([1, 1], [3, 1], "black", 1, false, false)
        @game_board.update_piece([3, 1], 1)
        @game_board.move_piece([3, 1], [4, 1], "black", 2, false, false)
        @game_board.update_piece([4, 1], 2)
        @game_board.move_piece([6, 0], [4, 0], "white", 3, false, false)
        @game_board.update_piece([4, 0], 3)
        expect(@game_board.en_passant([4, 1], [5, 0], "black", 4)).to eql("En passant performed.")
      end

      it "returns 'En passant performed.' after performing en passant right using the pawn at b7" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([1, 1], [3, 1], "black", 1, false, false)
        @game_board.update_piece([3, 1], 1)
        @game_board.move_piece([3, 1], [4, 1], "black", 2, false, false)
        @game_board.update_piece([4, 1], 2)
        @game_board.move_piece([6, 2], [4, 2], "white", 3, false, false)
        @game_board.update_piece([4, 2], 3)
        expect(@game_board.en_passant([4, 1], [5, 2], "black", 4)).to eql("En passant performed.")
      end

      it "returns 'Invalid piece movement, try again.' after after en passant left using the pawn at b2 on the wrong turn" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([1, 0], [3, 0], "black", 3, false, false)
        @game_board.update_piece([3, 0], 3)
        expect(@game_board.en_passant([3, 1], [2, 0], "white", 5)).to eql("Invalid piece movement, try again.")
      end
    end
  end

  describe "#move_piece" do
    context "given all pieces except pawns" do
      it "returns 'Invalid piece movement, try again.' after trying to move the white king into the threatening black rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.add_knights
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 7], [1, 7], "black", 1, false, false)
        @game_board.move_piece([1, 7], [1, 5], "black", 2, false, false)
        expect(@game_board.move_piece([7, 4], [6, 5], "white", 3, false, false)).to eql("Invalid piece movement, try again.")
      end

      it "returns 'Invalid piece movement, you are still in check.' after trying to move the white king into the black queen while in check." do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.add_knights
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 7], [1, 7], "black", 1, false, false)
        @game_board.move_piece([1, 7], [1, 4], "black", 2, false, false)
        expect(@game_board.move_piece([7, 4], [6, 3], "white", 3, false, true)).to eql("Invalid piece movement, you are still in check.")
      end

      it "returns 'Invalid piece movement, you are still in check.' after trying to move the white king into the black rook while in check." do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.add_knights
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 7], [1, 7], "black", 1, false, false)
        @game_board.move_piece([1, 7], [1, 4], "black", 2, false, false)
        expect(@game_board.move_piece([7, 4], [6, 4], "white", 3, false, true)).to eql("Invalid piece movement, you are still in check.")
      end

      it "returns 'Piece moved, you are no longer in check.' after moving a starting king away from a threatening rook" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.add_knights
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([0, 7], [1, 7], "black", 1, false, false)
        @game_board.move_piece([1, 7], [1, 4], "black", 2, false, false)
        expect(@game_board.move_piece([7, 4], [6, 5], "white", 3, false, true)).to eql("Piece moved, you are no longer in check.")
      end
    end

    context "given only kings and pawns" do
      it "returns 'En passant performed, you are no longer in check.' after the white king is in check" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.add_kings
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([6, 4], [5, 4], "white", 3, false, false)
        @game_board.update_piece([5, 4], 3)
        @game_board.move_piece([5, 4], [4, 4], "white", 4, false, false)
        @game_board.update_piece([4, 4], 4)
        @game_board.move_piece([4, 4], [3, 4], "white", 5, false, false)
        @game_board.update_piece([3, 4], 5)
        @game_board.move_piece([7, 4], [6, 4], "white", 6, false, false)
        @game_board.update_piece([6, 4], 6)
        @game_board.move_piece([6, 4], [5, 4], "white", 3, false, false)
        @game_board.update_piece([5, 4], 7)
        @game_board.move_piece([5, 4], [4, 4], "white", 4, false, false)
        @game_board.update_piece([4, 4], 8)
        @game_board.move_piece([4, 4], [4, 3], "white", 4, false, false)
        @game_board.update_piece([4, 3], 9)
        @game_board.move_piece([1, 2], [3, 2], "black", 7, false, false)
        @game_board.update_piece([3, 2], 10)
        expect(@game_board.move_piece([3, 1], [2, 2], "white", 11, false, true)).to eql("En passant performed, you are no longer in check.")
      end

      it "returns 'En passant performed, you are no longer in check.' after the black king is in check" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.add_kings
        @game_board.move_piece([1, 4], [3, 4], "black", 1, false, false)
        @game_board.update_piece([3, 4], 1)
        @game_board.move_piece([3, 4], [4, 4], "black", 2, false, false)
        @game_board.update_piece([4, 4], 2)
        @game_board.move_piece([4, 4], [5, 4], "black", 3, false, false)
        @game_board.update_piece([5, 4], 3)
        @game_board.move_piece([0, 4], [1, 4], "black", 4, false, false)
        @game_board.update_piece([1, 4], 4)
        @game_board.move_piece([1, 4], [2, 4], "black", 5, false, false)
        @game_board.update_piece([2, 4], 5)
        @game_board.move_piece([2, 4], [3, 4], "black", 6, false, false)
        @game_board.update_piece([3, 4], 6)
        @game_board.move_piece([1, 6], [3, 6], "black", 7, false, false)
        @game_board.update_piece([3, 6], 7)
        @game_board.move_piece([3, 6], [4, 6], "black", 8, false, false)
        @game_board.update_piece([4, 6], 8)
        @game_board.move_piece([6, 5], [4, 5], "white", 9, false, false)
        @game_board.update_piece([4, 5], 9)
        expect(@game_board.move_piece([4, 6], [5, 5], "black", 10, false, true)).to eql("En passant performed, you are no longer in check.")
      end
    end

    context "given only pawns, queens, and kings" do
      it "returns 'Invalid piece movement, you are still in check.' trying to perform en passant while the king is still in check after" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.add_kings
        @game_board.add_queens
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([6, 4], [5, 4], "white", 3, false, false)
        @game_board.update_piece([5, 4], 3)
        @game_board.move_piece([5, 4], [4, 4], "white", 4, false, false)
        @game_board.update_piece([4, 4], 4)
        @game_board.move_piece([4, 4], [3, 4], "white", 5, false, false)
        @game_board.update_piece([3, 4], 5)
        @game_board.move_piece([7, 4], [6, 4], "white", 6, false, false)
        @game_board.update_piece([6, 4], 6)
        @game_board.move_piece([6, 4], [5, 4], "white", 7, false, false)
        @game_board.update_piece([5, 4], 7)
        @game_board.move_piece([5, 4], [4, 4], "white", 8, false, false)
        @game_board.update_piece([4, 4], 8)
        @game_board.move_piece([4, 4], [4, 3], "white", 9, false, false)
        @game_board.update_piece([4, 3], 9)
        @game_board.move_piece([1, 3], [2, 3], "black", 10, false, false)
        @game_board.update_piece([2, 3], 10)
        @game_board.move_piece([3, 4], [2, 3], "white", 11, false, false)
        @game_board.update_piece([2, 3], 11)
        @game_board.move_piece([0, 3], [2, 3], "black", 12, false, false)
        @game_board.update_piece([2, 3], 12)
        @game_board.move_piece([1, 2], [3, 2], "black", 13, false, false)
        @game_board.update_piece([3, 2], 13)
        expect(@game_board.move_piece([3, 1], [2, 2], "white", 14, false, true)).to eql("Invalid piece movement, you are still in check.")
      end
    end
  end

  describe "#find_attackers" do
    context "given only pawns, queens, and kings" do
      it "returns the pieces that currently threaten the king" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.add_kings
        @game_board.add_queens
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([6, 4], [5, 4], "white", 3, false, false)
        @game_board.update_piece([5, 4], 3)
        @game_board.move_piece([5, 4], [4, 4], "white", 4, false, false)
        @game_board.update_piece([4, 4], 4)
        @game_board.move_piece([4, 4], [3, 4], "white", 5, false, false)
        @game_board.update_piece([3, 4], 5)
        @game_board.move_piece([7, 4], [6, 4], "white", 6, false, false)
        @game_board.update_piece([6, 4], 6)
        @game_board.move_piece([6, 4], [5, 4], "white", 7, false, false)
        @game_board.update_piece([5, 4], 7)
        @game_board.move_piece([5, 4], [4, 4], "white", 8, false, false)
        @game_board.update_piece([4, 4], 8)
        @game_board.move_piece([4, 4], [4, 3], "white", 9, false, false)
        @game_board.update_piece([4, 3], 9)
        @game_board.move_piece([1, 3], [2, 3], "black", 10, false, false)
        @game_board.update_piece([2, 3], 10)
        @game_board.move_piece([3, 4], [2, 3], "white", 11, false, false)
        @game_board.update_piece([2, 3], 11)
        @game_board.move_piece([0, 3], [2, 3], "black", 12, false, false)
        @game_board.update_piece([2, 3], 12)
        @game_board.move_piece([1, 2], [3, 2], "black", 13, false, false)
        @game_board.update_piece([3, 2], 13)
        expect(@game_board.find_attackers(@game_board.find_king("white"), "white")).to eql([[3, 2], [2, 3]])
      end
    end
  end

  describe "#possible_blocks" do
    context "given only pawns, queens, and kings" do
      it "returns the spaces of the queen leading to the king" do
        @game_board.create_board
        @game_board.add_pawns
        @game_board.add_kings
        @game_board.add_queens
        @game_board.move_piece([6, 1], [4, 1], "white", 1, false, false)
        @game_board.update_piece([4, 1], 1)
        @game_board.move_piece([4, 1], [3, 1], "white", 2, false, false)
        @game_board.update_piece([3, 1], 2)
        @game_board.move_piece([6, 4], [5, 4], "white", 3, false, false)
        @game_board.update_piece([5, 4], 3)
        @game_board.move_piece([5, 4], [4, 4], "white", 4, false, false)
        @game_board.update_piece([4, 4], 4)
        @game_board.move_piece([4, 4], [3, 4], "white", 5, false, false)
        @game_board.update_piece([3, 4], 5)
        @game_board.move_piece([7, 4], [6, 4], "white", 6, false, false)
        @game_board.update_piece([6, 4], 6)
        @game_board.move_piece([6, 4], [5, 4], "white", 7, false, false)
        @game_board.update_piece([5, 4], 7)
        @game_board.move_piece([5, 4], [5, 3], "white", 8, false, false)
        @game_board.update_piece([5, 3], 8)
        @game_board.move_piece([1, 3], [2, 3], "black", 9, false, false)
        @game_board.update_piece([2, 3], 9)
        @game_board.move_piece([3, 4], [2, 3], "white", 10, false, false)
        @game_board.update_piece([2, 3], 10)
        @game_board.move_piece([0, 3], [2, 3], "black", 11, false, false)
        @game_board.update_piece([2, 3], 11)
        @game_board.move_piece([1, 2], [3, 2], "black", 12, false, false)
        @game_board.update_piece([3, 2], 12)
        expect(@game_board.possible_blocks(@game_board.find_king("white"), "white")).to eql([[3, 3], [4, 3]])
      end
    end

    context "given only rooks, bishops, queens, and kings" do
      it "returns the spaces of the enemy pieces that can be blocked to remove check" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.add_bishops
        @game_board.add_queens
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        @game_board.update_piece([6, 4], 1)
        @game_board.move_piece([0, 2], [2, 0], "black", 2, false, false)
        @game_board.update_piece([2, 0], 2)
        @game_board.move_piece([0, 3], [1, 4], "black", 3, false, false)
        @game_board.update_piece([1, 4], 3)
        @game_board.move_piece([0, 7], [6, 7], "black", 4, false, false)
        @game_board.update_piece([6, 7], 4)
        expect(@game_board.possible_blocks(@game_board.find_king("white"), "white")).to eql([[2, 4], [3, 4], [4, 4], [5, 4], [6, 6], [6, 5], [3, 1], [4, 2], [5, 3]])
      end
    end
  end

  describe "#checkmate" do
    context "given a game where white has lost in two moves (Fool's Mate)" do
      it "returns true that white is in checkmate" do
        @game_board.create_board
        @game_board.add_pieces
        @game_board.move_piece([6, 5], [5, 5], "white", 1, false, false)
        @game_board.update_piece([5, 5], 1)
        @game_board.move_piece([1, 4], [3, 4], "black", 2, false, false)
        @game_board.update_piece([3, 4], 2)
        @game_board.move_piece([6, 6], [4, 6], "white", 3, false, false)
        @game_board.update_piece([4, 6], 3)
        @game_board.move_piece([0, 3], [4, 7], "black", 4, false, false)
        @game_board.update_piece([4, 7], 4)
        expect(@game_board.checkmate?("white")).to eql(true)
      end
    end

    context "given a game where there is only the black king, white king, and white queen" do
      it "returns true when the black king is pinned to e8" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_queens
        @game_board.move_piece([7, 4], [6, 4], "white", 1, false, false)
        @game_board.move_piece([6, 4], [5, 4], "white", 2, false, false)
        @game_board.move_piece([5, 4], [4, 4], "white", 3, false, false)
        @game_board.move_piece([4, 4], [3, 4], "white", 4, false, false)
        @game_board.move_piece([3, 4], [2, 4], "white", 5, false, false)
        @game_board.move_piece([7, 3], [0, 3], "white", 6, false, false)
        @game_board.move_piece([0, 3], [1, 4], "white", 7, false, false)
        expect(@game_board.checkmate?("black")).to eql(true)
      end
    end

    context "given a game where there is only a white rook, white king, and black king" do
      it "returns true when the king is pinned to d1 (right triangle mate)" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_rooks
        @game_board.move_piece([0, 4], [0, 3], "black", 1, false, false)
        @game_board.move_piece([7, 4], [6, 3], "white", 1, false, false)
        @game_board.move_piece([0, 0], [7, 0], "black", 1, false, false)
        @game_board.move_piece([7, 7], [7, 0], "white", 1, false, false)
        @game_board.move_piece([7, 0], [7, 7], "white", 1, false, false)
        @game_board.move_piece([6, 3], [5, 3], "white", 1, false, false)
        @game_board.move_piece([5, 3], [4, 3], "white", 1, false, false)
        @game_board.move_piece([4, 3], [3, 3], "white", 1, false, false)
        @game_board.move_piece([3, 3], [2, 3], "white", 1, false, false)
        @game_board.move_piece([7, 7], [0, 7], "white", 1, false, false)
        @game_board.move_piece([0, 3], [0, 2], "black", 1, false, false)
        @game_board.move_piece([2, 3], [2, 2], "white", 1, false, false)
        @game_board.move_piece([0, 2], [0, 1], "black", 1, false, false)
        @game_board.move_piece([2, 2], [2, 1], "white", 1, false, false)
        @game_board.move_piece([0, 1], [0, 0], "black", 1, false, false)
        @game_board.move_piece([2, 1], [2, 0], "white", 1, false, false)
        expect(@game_board.checkmate?("black")).to eql(true)
      end
    end

    context "given a game where there is only two white bishops, white king, and black king" do
      it "returns true when the king is pinned to a8" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_bishops
        @game_board.move_piece([7, 2], [5, 0], "white", 1, false, false)
        @game_board.move_piece([7, 5], [5, 7], "white", 1, false, false)
        @game_board.move_piece([5, 0], [0, 5], "white", 1, false, false)
        @game_board.move_piece([5, 7], [0, 2], "white", 1, false, false)
        @game_board.move_piece([0, 2], [2, 4], "white", 1, false, false)
        @game_board.move_piece([2, 4], [0, 6], "white", 1, false, false)
        @game_board.move_piece([0, 4], [0, 3], "black", 1, false, false)
        @game_board.move_piece([0, 3], [0, 2], "black", 1, false, false)
        @game_board.move_piece([0, 2], [0, 1], "black", 1, false, false)
        @game_board.move_piece([0, 1], [0, 0], "black", 1, false, false)
        @game_board.move_piece([7, 4], [7, 3], "white", 1, false, false)
        @game_board.move_piece([7, 3], [7, 2], "white", 1, false, false)
        @game_board.move_piece([7, 2], [7, 1], "white", 1, false, false)
        @game_board.move_piece([7, 1], [6, 1], "white", 1, false, false)
        @game_board.move_piece([6, 1], [5, 1], "white", 1, false, false)
        @game_board.move_piece([5, 1], [4, 1], "white", 1, false, false)
        @game_board.move_piece([4, 1], [3, 1], "white", 1, false, false)
        @game_board.move_piece([3, 1], [2, 1], "white", 1, false, false)
        @game_board.move_piece([0, 5], [2, 3], "white", 1, false, false)
        @game_board.move_piece([2, 3], [1, 2], "white", 1, false, false)
        expect(@game_board.checkmate?("black")).to eql(true)
      end
    end

    context "given a game where there is only two white bishops, white king, and black king" do
      it "returns true when the king is pinned to a8" do
        @game_board.create_board
        @game_board.add_kings
        @game_board.add_bishops
        @game_board.add_knights
        @game_board.move_piece([0, 1], [2, 0], "black", 1, false, false)
        @game_board.move_piece([0, 6], [2, 7], "black", 1, false, false)
        @game_board.move_piece([7, 5], [2, 0], "white", 1, false, false)
        @game_board.move_piece([2, 0], [7, 5], "white", 1, false, false)
        @game_board.move_piece([7, 2], [2, 7], "white", 1, false, false)
        @game_board.move_piece([2, 7], [7, 2], "white", 1, false, false)
        @game_board.move_piece([7, 1], [5, 0], "white", 1, false, false)
        @game_board.move_piece([0, 5], [5, 0], "black", 1, false, false)
        @game_board.move_piece([5, 0], [0, 5], "black", 1, false, false)
        @game_board.move_piece([0, 2], [2, 0], "black", 1, false, false)
        @game_board.move_piece([7, 5], [2, 0], "white", 1, false, false)
        @game_board.move_piece([2, 0], [7, 5], "white", 1, false, false)
        @game_board.move_piece([7, 2], [5, 0], "white", 1, false, false)
        @game_board.move_piece([0, 5], [5, 0], "black", 1, false, false)
        @game_board.move_piece([5, 0], [7, 2], "black", 1, false, false)
        @game_board.move_piece([7, 4], [7, 3], "white", 1, false, false)
        @game_board.move_piece([7, 3], [7, 2], "white", 1, false, false)
        @game_board.move_piece([0, 4], [0, 3], "black", 1, false, false)
        @game_board.move_piece([0, 3], [0, 2], "black", 1, false, false)
        @game_board.move_piece([0, 2], [0, 1], "black", 1, false, false)
        @game_board.move_piece([0, 1], [0, 0], "black", 1, false, false)
        @game_board.move_piece([7, 2], [6, 1], "white", 1, false, false)
        @game_board.move_piece([7, 6], [6, 4], "white", 1, false, false)
        @game_board.move_piece([6, 4], [7, 2], "white", 1, false, false)
        @game_board.move_piece([7, 2], [6, 0], "white", 1, false, false)
        @game_board.move_piece([6, 0], [4, 1], "white", 1, false, false)
        @game_board.move_piece([4, 1], [2, 0], "white", 1, false, false)
        @game_board.move_piece([6, 1], [5, 1], "white", 1, false, false)
        @game_board.move_piece([5, 1], [4, 1], "white", 1, false, false)
        @game_board.move_piece([4, 1], [3, 1], "white", 1, false, false)
        @game_board.move_piece([3, 1], [2, 1], "white", 1, false, false)
        @game_board.move_piece([7, 5], [6, 6], "white", 1, false, false)
        @game_board.move_piece([6, 6], [2, 2], "white", 1, false, false)
        expect(@game_board.checkmate?("black")).to eql(true)
      end
    end

    context "given a game where black has lost in four moves (Scholar's Mate)" do
      it "returns true that white is in checkmate" do
        @game_board.create_board
        @game_board.add_pieces
        @game_board.move_piece([6, 4], [4, 4], "white", 1, false, false)
        @game_board.move_piece([1, 4], [3, 4], "black", 1, false, false)
        @game_board.move_piece([7, 3], [3, 7], "white", 1, false, false)
        @game_board.move_piece([0, 1], [2, 2], "black", 1, false, false)
        @game_board.move_piece([7, 5], [4, 2], "white", 1, false, false)
        @game_board.move_piece([0, 6], [2, 5], "black", 1, false, false)
        @game_board.move_piece([3, 7], [1, 5], "white", 1, false, false)
        expect(@game_board.checkmate?("black")).to eql(true)
      end
    end

  end

  describe "#all_king_moves" do
    context "given a starting board" do
      it "returns all possible moves in an array for the king possible on the board without interference" do
        @game_board.create_board
        @game_board.add_pieces
        expect(@game_board.all_king_moves("white")).to eql([[6, 4], [6, 3], [6, 5], [7, 3], [7, 5]])
      end
    end
  end

end