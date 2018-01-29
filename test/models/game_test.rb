require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "should not expire new games" do
    game = Game.new(name: "TESTG")
    game.save

    assert_not(game.expired?)
  end

  test "should delete expired games" do
    game = Game.new(name: "OLDGA", created_at: DateTime.new - 1)
    game.save

    assert game.expired?
    assert_includes Game.expired_games, game
    
    Game.scrub_games

    assert_not_includes Game.expired_games, game
  end

  test "should have unique names" do
    Game.new(name: "TESTG").save
    assert_not Game.new(name: "TESTG").save
  end

end
