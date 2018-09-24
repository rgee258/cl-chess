require "game"

describe Game do

	before (:each) do
		@game = Game.new
	end

	describe "#convert_to_index" do
		context "given the board letter a" do
			it "returns the corresponding array index 7" do
				expect(@game.convert_to_index("a")).to eql(7)
			end
		end

		context "given the board letter h" do
			it "returns the corresponding array index 0" do
				expect(@game.convert_to_index("h")).to eql(0)
			end
		end

		context "given the character 1" do
			it "returns the corresponding array index 0" do
				expect(@game.convert_to_index("1")).to eql(0)
			end
		end

		context "given the character 8" do
			it "returns the corresponding array index 0" do
				expect(@game.convert_to_index("8")).to eql(7)
			end
		end
	end

end