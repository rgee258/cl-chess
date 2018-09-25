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

	describe "#valid_pawn?" do
		context "given a starting board" do
			it "returns true moving the left most white pawn forward once" do
				@game_board.create_board
				@game_board.add_pieces
				expect(@game_board.valid_pawn?([6, 0], [5, 0], "white")).to eql(true)
			end

			it "returns true moving the left most white pawn forward twice from start" do
				@game_board.create_board
				@game_board.add_pieces
				expect(@game_board.valid_pawn?([6, 0], [4, 0], "white")).to eql(true)
			end
		end

		context "given a board where the second left white pawn can capture" do
			it "returns true when the left diagonal piece is capturable" do
				@game_board.create_board
				@game_board.add_pieces
				@game_board.move_piece([1, 0], [3, 0], "black")
				@game_board.move_piece([3, 0], [4, 0], "black")
				@game_board.move_piece([6, 1], [5, 1], "white")
				expect(@game_board.valid_pawn?([5, 1], [4, 0], "white")).to eql(true)
			end

			it "returns true when the right diagonal piece is capturable" do
				@game_board.create_board
				@game_board.add_pieces
				@game_board.move_piece([1, 2], [3, 2], "black")
				@game_board.move_piece([3, 2], [4, 2], "black")
				@game_board.move_piece([6, 1], [5, 1], "white")
				expect(@game_board.valid_pawn?([5, 1], [4, 2], "white")).to eql(true)
			end
		end
	end


	describe "#valid_knight?" do
		context "given only knights moving the left white knight" do
			it "returns true moving a white knight at c3 up 2 and left 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [3, 1], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 up 2 and right 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [3, 3], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 left 2 and up 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [4, 0], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 left 2 and down 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [6, 0], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 right 2 and up 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [4, 4], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 right 2 and down 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [6, 4], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 down 2 and left 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [7, 1], "white")).to eql(true)
			end

			it "returns true moving a white knight at c3 down 2 and right 1" do
				@game_board.create_board
				@game_board.add_knights
				@game_board.move_piece([7, 1], [5, 2], "white")
				expect(@game_board.valid_knight?([5, 2], [7, 3], "white")).to eql(true)
			end
		end

		context "given only knights in starting position" do
			it "returns false moving the left white knight down 2 and left 1" do
				@game_board.create_board
				@game_board.add_knights
				expect(@game_board.valid_knight?([7, 1], [9, 0], "white")).to eql(false)
			end

			it "returns false moving the right white knight down 2 and right 1" do
				@game_board.create_board
				@game_board.add_knights
				expect(@game_board.valid_knight?([7, 6], [9, 7], "white")).to eql(false)
			end

			it "returns false moving the left black knight up 2 and left 1" do
				@game_board.create_board
				@game_board.add_knights
				expect(@game_board.valid_knight?([0, 1], [-2, 0], "white")).to eql(false)
			end

			it "returns false moving the right black knight up 2 and right 1" do
				@game_board.create_board
				@game_board.add_knights
				expect(@game_board.valid_knight?([0, 6], [-2, 7], "white")).to eql(false)
			end
		end
	end

	describe "#valid_rook?" do
		context "given only rooks moving the left white rook" do
			it "returns true moving a white rook at b2 to a2" do
				@game_board.create_board
				@game_board.add_rooks
				@game_board.move_piece([7, 0], [6, 0], "white")
				@game_board.move_piece([6, 0], [6, 1], "white")
				expect(@game_board.valid_rook?([6, 1], [6, 0], "white")).to eql(true)
			end

			it "returns true moving a white rook at b2 to h2" do
				@game_board.create_board
				@game_board.add_rooks
				@game_board.move_piece([7, 0], [6, 0], "white")
				@game_board.move_piece([6, 0], [6, 1], "white")
				expect(@game_board.valid_rook?([6, 1], [6, 7], "white")).to eql(true)
			end

			it "returns true moving a white rook at b2 to b1" do
				@game_board.create_board
				@game_board.add_rooks
				@game_board.move_piece([7, 0], [6, 0], "white")
				@game_board.move_piece([6, 0], [6, 1], "white")
				expect(@game_board.valid_rook?([6, 1], [7, 1], "white")).to eql(true)
			end

			it "returns true moving a white rook at b2 to b8" do
				@game_board.create_board
				@game_board.add_rooks
				@game_board.move_piece([7, 0], [6, 0], "white")
				@game_board.move_piece([6, 0], [6, 1], "white")
				expect(@game_board.valid_rook?([6, 1], [0, 1], "white")).to eql(true)
			end
		end

		context "given only rooks in starting position" do
			it "returns false moving a white rook at a1 to b2" do
				@game_board.create_board
				@game_board.add_rooks
				expect(@game_board.valid_rook?([7, 0], [6, 1], "white")).to eql(false)
			end

			it "returns false moving a white rook at h1 to g2" do
				@game_board.create_board
				@game_board.add_rooks
				expect(@game_board.valid_rook?([7, 7], [6, 6], "white")).to eql(false)
			end

			it "returns false moving a black rook at a8 off the board" do
				@game_board.create_board
				@game_board.add_rooks
				expect(@game_board.valid_rook?([0, 0], [0, -1], "white")).to eql(false)
			end
		end
	end

end