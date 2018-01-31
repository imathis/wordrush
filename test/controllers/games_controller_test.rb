require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "new game" do
    post games_path, params: { }

    assert_response :redirect
    assert_redirected_to new_game_player_path(Game.last), "Redirects to new Player for Game \"#{Game.last.name}\""

  end

  test "join game" do
    post join_path, params: { name: 'GAME_READY' }
    assert_redirected_to new_game_player_path(game_name: 'GAME_READY'), "Redirects to new Player for Game \"GAME_READY\""
  end

  test "should not join started game" do
    game = Game.find_by_name('GAME_READY')
    #post join_path, params: { name: 'GAME_READY' }
    #assert_redirected_to new_game_player_path(game_name: 'GAME_READY'), "Redirects to new Player for Game \"GAME_READY\""
  end
end
