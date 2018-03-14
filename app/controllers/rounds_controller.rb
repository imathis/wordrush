class RoundsController < ApplicationController
  def create

    @game = Game.find_by_name(params[:game_name])

    # Not ready to start
    if !@game.ready?
      flash[:error] = if !@game.players_ready?
        "Some players are still entering their words."
      else
        need = @game.needed_players
        "You need #{need} more #{"players".pluralize(need)} to begin."
      end

      redirect_to game_path @game
    # Ready/Started
    else
      if @game.rounds.empty?
        @game.start 
      elsif @game.current_round.finished?
        @game.new_round
      end

      redirect_to play_round_path @game
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
      if @round.number == 3
        redirect_to game_results_path @game
      else
        render "_results"
      end
    elsif @round.turn_active?
      redirect_to play_turn_path @game
    else
      @round.start_turn
      redirect_to play_turn_path @game
    end
  end
end
