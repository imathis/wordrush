require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test "add player" do
    post game_players_path(Game.last), params: { player: { name: 'Player1' }}
    assert_redirected_to new_player_word_path(player_id: Player.last.id), "Redirects to new Word for Player \"#{Player.last.name}\""
  end
end
