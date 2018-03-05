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

def self.play_turn(game, limit=60)
  turn = game.current_turn
  turn_start = Time.now
  turn_duration = 0
  play_start = turn_start
  ended = false
  count = 0

  while turn_duration < limit
    play = (3500..15000).to_a.sample / 1000.to_f

    if limit < play + turn_duration
      play = limit - turn_duration
      ended = true
    end

    turn_duration += play
    play_stop = play_start.advance(seconds: play)

    unless Game.last.current_round.finished?
      turn.plays.create({
        word: Game.last.current_turn.next_word,
        round: turn.round,
        player: turn.player,
        created_at: play_start,
        updated_at: play_stop,
        duration: play,
        guessed: !ended,
        index: count
      })
    end

    play_start = play_stop
    count += 1
  end

end

library = %w(trees ocean camera syrup lens lake child salsa lamp dessert grill fence candy fire lightning curls olympics patio stapler umbrella tub bath bubbles Epsom\ salt Netflix kittens pantry feet hats tempest painting bourbon trust rushed curious worthy simple expenses contract experience crying help twist lemon pear grape bananas argument wonder shock theology funions).shuffle

# Create a game which is ready to be played
# It has four players, each with five words
add_game('GAME_READY', %w(Michael Jim Dwight Stanley), library.dup)
add_game('GAME_NOT_READY', %w(Susan Alice Jacob), library.first(14))

game = add_game('GAME_STARTED', %w(John Paul George Ringo), library.dup)
game.start.start_turn
play_turn Game.last, 55


game = add_game('TURN_DONE', %w(Hulk Storm Spidey Black\ Widow Thor), library.dup)
game.start

while !Game.last.current_round.finished?
  Game.last.current_round.start_turn
  play_turn Game.last
end

# Create a game which is not ready
# It only has three players
# The last player has only four words

p "Created #{Game.count} "+ "game".pluralize(Game.count)
