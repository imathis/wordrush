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

  test "should start a game when ready" do
    game = Game.find_by_name('GAME_READY')
    assert_not game.started?, "Game has not started"
    assert game.ready?, "Game is ready"
    assert game.start, "Game started"
    assert game.started?, "Game started? is true"
  end

  test "should NOT start a game which is not ready" do
    game = Game.find_by_name('GAME_NOT_READY')
    assert_not game.started?, "Game has not started"
    assert_not game.ready?, "Game is not ready"
    assert_not game.start, "Game was started"
    assert_not game.started?, "Game started? is false"
  end

  test "should have words" do
    words = Game.find_by_name('GAME_READY').words
    assert words.size > 0
  end

  test "should not be ready when players are not ready" do
    assert_not Game.find_by_name('GAME_NOT_READY').ready?
  end

  test "should have a play order" do
    game = Game.find_by_name('GAME_READY')
    assert_equal game.play_order, game.play_order
  end
end
