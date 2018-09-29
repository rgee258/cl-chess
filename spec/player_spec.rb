require "player"

describe Player do

  before (:each) do
    @player = Player.new("Bob", "white")
  end

  describe "#name" do
    context "given a player named Bob" do
      it "returns the name Bob" do
        expect(@player.name).to eql("Bob")
      end
    end
  end

  describe "#color" do
    context "given a player whose board color is white" do
      it "returns the color white" do
        expect(@player.color).to eql("white")
      end
    end
  end

  describe "#check" do
    context "given a new player" do
      it "returns false as the game has just started and check is not possible" do
        expect(@player.check).to eql(false)
      end
    end
  end

  describe "#castling" do
    context "given a new player" do
      it "returns false as the game has just started and castling is not possible" do
        expect(@player.castling_used).to eql(false)
      end
    end
  end

end