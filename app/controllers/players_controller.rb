class PlayersController < ApplicationController
  def create

    @game = Game.find_by_name(params[:game_name])
    @player = @game.players.create(player_params(@game))
    
    redirect_to controller: "players", action: "show", id: @player.id
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

  def player_params(game)
    p = params.require(:player).permit(:name)
    p[:team] = game.players.size % 2
    p
  end
end
