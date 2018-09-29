require "piece"

describe Piece do

  before (:each) do
    @piece = Piece.new("P", "white")
  end

  describe "#type" do
    context "given a new piece that is a white pawn" do
      it "returns P as the piece type" do
        expect(@piece.type).to eql("P")
      end
    end
  end

  describe "#color" do
    context "given a new piece that is a white pawn" do
      it "returns white as the piece color" do
        expect(@piece.color).to eql("white")
      end
    end
  end

  describe "#last_moved" do
    context "given a new piece that is a white pawn" do
      it "returns 0 for the turn the piece was last moved" do
        expect(@piece.last_moved).to eql(0)
      end
    end
  end

  describe "#times_moved" do
    context "given a new piece that is a white pawn" do
      it "returns 0 for the amount of times the piece was moved" do
        expect(@piece.times_moved).to eql(0)
      end
    end
  end

end