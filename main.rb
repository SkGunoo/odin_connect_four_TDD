# frozen_string_literal: true

# connect 4 rules
# usually 7 columns and x6 rows
# when there are 4 connected tokens
# -vertially , horizontally and diagonally
# things to watch out
# make sure the tokens to drop the lowest possible row
require_relative 'lib/connectFour.rb'
require_relative 'lib/Board.rb'
require_relative 'lib/Player.rb'
require_relative 'lib/Winchecker.rb'


game = ConnectFour.new
game.play_game
