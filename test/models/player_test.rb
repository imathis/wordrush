require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "should add a player" do
    assert Game.first.players.create!({ name: "Bob" })
    assert_equal Game.first.players.last.name, "Bob"
  end

  test "should make first player an admin" do
    game = Game.create!(name: 'TESTGAME')
    game.players.create!(name: 'AdminPlayer')
    assert game.players.first.admin
  end

  test "should choose teams for players" do
    game = Game.create!(name: 'TESTGAME2')
    game.players.create!(name: 'test player 1')
    game.players.create!(name: 'test player 2')
    game.players.create!(name: 'test player 3')

    assert_equal game.players[0].team, 0
    assert_equal game.players[1].team, 1
    assert_equal game.players[2].team, 0
  end
end
