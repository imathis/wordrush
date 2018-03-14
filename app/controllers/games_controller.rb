class GamesController < ApplicationController
  def create
    @game = Game.new name: Game.short_code, one_device: game_params[:one_device]

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
    redirect_to games_path end

  def join
    @game = Game.find_by_name(params[:name].upcase)

    if @game
      unless @game.started?
        redirect_to new_game_player_path(@game)
      else
        flash[:info] = "Sorry, you can't join a game which has already begun. Start a new game?"
        redirect_to "/"
      end
    else
      # TODO: 404 redirection
      redirect_to "/"
    end
  end

  def start
    @game = Game.find_by_name(params[:name].upcase)

    if @game.start
      redirect_to new_game_player_path(@game)
    else
      # TODO: 404 redirection
      redirect_to game_path
    end

  end

  def results
    @game = Game.find_by_name(params[:name])
  end

  private

  def game_params
    params.require(:game).permit(:one_device)
  end
end
