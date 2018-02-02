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
  game = Game.create!( name: name)
  add_players(game, players)
  add_words(game.players, words)
  game
end

library = %w(trees ocean camera syrup lens lake child salsa lamp dessert grill fence candy fire lightning curls olympics patio stapler umbrella tub bath bubbles Epsom\ salt Netflix)

# Create a game which is ready to be played
# It has four players, each with five words
add_game('GAME_READY', %w(Michael Jim Dwight Stanley), library)

game = add_game('GAME_STARTED', %w(Hulk Storm Spidey Black\ Widow Thor), library)
game.rounds.create()

# Create a game which is not ready
# It only has three players
# The last player has only four words
add_game('GAME2', %w(Susan Alice Jacob), library.first(14))

p "Created #{Game.count} "+ "game".pluralize(Game.count)
