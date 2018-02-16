class RoundsController < ApplicationController
  def create

    @game = Game.find_by_name(params[:game_name])

    if @game.ready?
      @game.start
      redirect_to play_round_path @game
    else
      flash[:error] = if !@game.players_ready?
        "Some players are still entering their words."
      else
        need = @game.needed_players
        "You need #{need} more #{"players".pluralize(need)} to begin."
      end

      redirect_to game_path @game
    end
  end

  def next_turn
    @round = Round.find(params[:id])
    redirect_to play_round_path @round.game
  end

  def play
    @game = Game.find_by_name(params[:name].upcase)
    @round = @game.current_round
    if @round.new?
      render "_start"
    elsif @round.finished?
      render "_results"
    elsif @round.turn_active?
      redirect_to play_turn_path @game
    end
  end
end
