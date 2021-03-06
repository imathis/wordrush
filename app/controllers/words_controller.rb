class WordsController < ApplicationController
  def index
    @game = Game.find_by_name(params[:game_name])
    @player = Player.find(params[:player_id])
    @words = @player.words
  end

  def create
    @player = Player.find(params[:player_id])
    begin
      @player.words.create(word_params)
    rescue NameError => e
      flash[:error] = e
    end
    
    if @player.ready?
      redirect_to game_path(@player.game)
    else
      redirect_to new_player_word_path(player_id: @player.id)
    end
  end

  def new
    @player = Player.find(params[:player_id])
  end

  private

  def word_params
    params.require(:word).permit(:name)
  end
end
