class GamesController < ApplicationController
  def create
    @game = Game.new name: Game.short_code

    while !@game.save do
      @game.name = Game.short_code
    end

    redirect_to new_game_player_path(@game)
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
    @game = Game.find_by_name(params[:name].upcase)

    if @game
      redirect_to new_game_player_path(@game)
    else
      # TODO: 404 redirection
      redirect_to "/"
    end
  end

end
