require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "should add a player" do
    assert Game.first.players.create!({ name: "Bob" })
    assert_equal Game.first.players.last.name, "Bob"
  end
end
