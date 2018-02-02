require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  test "Rounds creation" do
    game = Game.last
    round = game.rounds.create()
    binding.pry
  end
end
