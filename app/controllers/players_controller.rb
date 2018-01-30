class PlayersController < ApplicationController
  def create
    @game = Game.find_by_name(params[:game_name])
    pparams = player_params

    # Split players among two teams
    pparams[:team] = @game.players.size % 2
    pparams[:admin] = @game.players.size == 1

    @player = @game.players.create(pparams)
    
    redirect_to new_player_word_path(player_id: @player.id)
  end

  def new
    @game = Game.find_by_name(params[:game_name])
  end

  def index
    @game = Game.find_by_name(params[:game_name])
  end

  def show
    @game = Game.find_by_name(params[:game_name])
    @player = Player.find(params[:id])
  end

  def destroy
    Player.find(params[:id]).destroy
    redirect_to games_path
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
