class TurnsController < ApplicationController
  def play
    @game = Game.find_by_name(params[:name].upcase)
    @turn = @game.current_turn
    if @turn.new?
      render "_new"
    elsif @turn.finished?
      render "_results"
    else
      render "_card"
    end
  end
end
