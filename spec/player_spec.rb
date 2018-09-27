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

end