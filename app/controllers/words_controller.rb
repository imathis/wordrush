class WordsController < ApplicationController
  def index
    @game = Game.find_by_name(params[:game_name])
    @player = Player.find(params[:player_id])
    @words = @player.words
  end

  def create
    @player = Player.find(params[:player_id])
    @player.words.create(word_params)
    
    redirect_to controller: "players", action: "show", id: @player.id
  end

  private

  def word_params
    params.require(:word).permit(:name)[:name]
  end
end
