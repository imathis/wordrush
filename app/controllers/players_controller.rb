class PlayersController < ApplicationController
  def create
    @game = Game.find_by_name(params[:game_name])
    pparams = player_params

    begin
      @player = @game.players.create(pparams)

      session[:current_player_id] = @player.id if session[:current_player_id].nil?
      session[:current_game_id] = @game.id
      redirect_to new_player_word_path(@player)
    rescue NameError => e
      flash[:error] = e
      redirect_to new_game_player_path(@game)
    end
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
