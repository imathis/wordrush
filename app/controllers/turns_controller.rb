class TurnsController < ApplicationController
  def create
    @game = Game.find_by_name(params[:game_name].upcase)
    @round = @game.current_round
    @round.start_turn
    redirect_to play_turn_path @game
  end

  def end
    @turn = Turn.find(params[:id])
    @turn.finish
    
    redirect_to play_turn_path @turn.game
  end

  def next_word
    @turn = Turn.find(params[:id])
    @turn.play_word

    redirect_to play_turn_path @turn.game
  end

  def play
    @game = Game.find_by_name(params[:name])
    @turn = @game.current_turn
    if @turn.new?
      render "_start"
    elsif @turn.finished?
      render "_results"
    else
      render "_card"
    end
  end
end
