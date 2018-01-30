require 'test_helper'

class WordsControllerTest < ActionDispatch::IntegrationTest
  test "add word" do
    player = Player.first
    post player_words_path(player), params: { word: { name: 'tiger' }}
    assert_equal Word.last.name, 'tiger', "Word should equal tiger"
  end
end
