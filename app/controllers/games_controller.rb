class GamesController < ApplicationController
  def create
    @game = Game.new(game_params)
    @game.save

    redirect_to action: "show", name: @game.name
  end

  def index
    @games = Game.all
  end

  def show
    @game = Game.find_by_name(params[:name])
  end

  def destroy
    Game.find_by_name(params[:name]).destroy
    redirect_to games_path
  end

  def join
    @game = Game.find_by_name(params[:name])
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
