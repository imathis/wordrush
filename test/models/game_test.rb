require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "should have unique names" do
    assert Game.create(name: "UNIQUE")
    exception = assert_raises(Exception){ Game.create!(name: "UNIQUE") }
    assert_equal "Validation failed: Name has already been taken", exception.message
  end

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
end
