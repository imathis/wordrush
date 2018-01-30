require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "creates a new game" do
    visit new_game_path
    assert_selector "h1", text: "New Game"

    click_on "New Game"

    assert_redirected_to new_game_player_path(game_id: Game.last)
  end
end
