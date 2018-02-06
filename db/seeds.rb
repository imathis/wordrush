# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Game.destroy_all
 
def self.new_player(name, options={})
  {
    name: name
  }.merge(options)
end

def self.player_word(name)
  {
    name: name
  }
end

def self.add_players(game, names)
  players = names.map{ |n| new_player(n) }
  game.players.create players
end

def self.add_words(players, words)
  players.each do |player|
    w = words.shift(5).map{ |w| player_word(w) }
    player.words.create w
  end
end

def self.add_game(name, players, words)
  game = Game.create! name: name, one_device: true
  add_players game, players
  add_words game.players, words
  game
end

def self.play_turn(game, seconds=60)
  turn = game.current_turn
  turn_limit = 1000 * seconds
  turn_duration = 0

  while turn_duration < turn_limit
    play_duration = (4000..15000).to_a.sample
    turn_duration += play_duration

    if Game.last.current_round.plays_left?
      turn.plays.create({
        word: Game.last.current_turn.next_word,
        round: turn.round,
        player: turn.player,
        duration: turn_limit < turn_duration ? nil : play_duration
      })
    end
  end

  # If player has hit the limit, start a new turn
  if 60000 <= turn_duration
    Game.last.current_round.start_turn
  end
end

library = %w(trees ocean camera syrup lens lake child salsa lamp dessert grill fence candy fire lightning curls olympics patio stapler umbrella tub bath bubbles Epsom\ salt Netflix)

# Create a game which is ready to be played
# It has four players, each with five words
add_game('GAME_READY', %w(Michael Jim Dwight Stanley), library.dup)
add_game('GAME_NOT_READY', %w(Susan Alice Jacob), library.first(14))

game = add_game('GAME_STARTED', %w(John Paul George Ringo), library.dup)
game.start.start_turn
play_turn Game.last, 40


game = add_game('TURN_DONE', %w(Hulk Storm Spidey Black\ Widow Thor), library.dup)
game.start.start_turn

while Game.last.current_round.plays_left?
  play_turn Game.last
end

# Create a game which is not ready
# It only has three players
# The last player has only four words

p "Created #{Game.count} "+ "game".pluralize(Game.count)
