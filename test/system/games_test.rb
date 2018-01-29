require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "creates a new game" do
    visit new_game_path
    assert_selector "h1", text: "New Game"

    click_on "New Game"

    assert_selector "h1", text: "Welcome to WordRush"
  end
end
