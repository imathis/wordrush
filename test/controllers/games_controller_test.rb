require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "new game" do
    post games_path, params: { }

    assert_response :redirect
    assert_redirected_to new_game_player_path(Game.last), "Redirects to new Player for Game \"#{Game.last.name}\""

  end

  test "join game" do
    post join_path, params: { name: 'GAME1' }
    assert_redirected_to new_game_player_path(game_name: 'GAME1'), "Redirects to new Player for Game \"GAME1\""
  end
end
