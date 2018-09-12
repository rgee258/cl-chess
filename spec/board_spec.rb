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

end