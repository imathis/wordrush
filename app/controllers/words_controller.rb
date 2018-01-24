class WordsController < ApplicationController
  def create

    @player = Player.find(params[:player_id])
    word_params.each do |word|
      @word = @player.words.create(name: word)
    end
    
    redirect_to controller: "players", action: "show", id: @player.id
  end

  private

  def word_params
    entry = params.require(:word).permit(:name)[:name]
    entry.to_s.split("\n")
  end
end
