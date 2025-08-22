# frozen_string_literal: true

# connect 4 rules
# usually 7 columns and x6 rows
# when there are 4 connected tokens
# -vertially , horizontally and diagonally
# things to watch out
# make sure the tokens to drop the lowest possible row

# what does user need to do
# place a toekn

class ConnectFour
  attr_reader :winner

  def initialize
    # welcome_message
    @board = Board.new
    @player_one = Player.new('➀', 'player_one')
    @player_two = Player.new('➁', 'player_two')
    @current_player = @player_one
    @winner = nil
    @win_checker = Winchecker.new
    @game_draw = false
  end

  def play_game
    until @game_draw || @winner
      column = ask_for_column
      @board.place_token_to_column(column, @current_player.shape)
      @winner = @win_checker.win_check(@board.last_placed_token, @current_player)
      @game_draw = @board.draw_check
      switch_player
    end
    # this draws a board when there is a winner
    @board.draw_board
  end

  private

  # might not need this
  def place_token
    column = ask_for_column
    @board.place_token_to_column(column, @current_player.shape)

    # check if board is full
    # or that column is full
  end

  def ask_for_column
    @board.draw_board
    puts 'current board layout ↑ '
    ask_for_number
    # #show board using draw_board
    # and puts a msg
    # #{current_player} which column you want to place the token
    # #check for right input repeat the puts if input is incorrect
  end

  def ask_for_number
    input = nil
    until input
      puts "#{@current_player.name} which column you want to place token?(1 - 7)"
      # -1 to answer because of actual column index is 0 - 6
      answer = gets.chomp.to_i - 1
      input = answer if (0..6).include?(answer) && @board.not_full?(answer)
    end
    # -1 because array index start from 0
    input
  end

  def switch_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def draw_board
    @board.draw_board
  end
end

class Board
  attr_reader :board, :last_placed_token

  def initialize(board_row = 4, board_column = 7)
    @board_row = board_row
    @board_column = board_column
    @board = Array.new(4) { Array.new(7) }
    # this is used for checking winner
    # and the structure of it is :[row,column,shape,@board]
    @last_placed_token = nil
  end

  def draw_board
    draw_board_bottom
    full_board = []
    @board.each do  |row|
      full_board << draw_row(row)
    end
    # reverse the board so that [0][0]
    # is at the left bottom corner
    puts full_board.reverse
  end

  def place_token_to_column(column, shape)
    number_of_rows = @board_row.size
    number_of_rows.times do |num|
      next unless @board[num][column].nil?

      @board[num][column] = shape == '➀' ? red_text(shape.center(3)) : blue_text(shape.center(3))
      @last_placed_token = [num, column, shape, @board]
      message_after_placement(shape, num, column)
      break
    end
  end

  # gets called by #ask_for_number in ConnectFour class
  def not_full?(column_number)
    column = get_column_tokens(column_number)
    # return false if column is full
    return true unless column.size == @board_row

    puts 'that column is full!'
    false
  end

  def draw_check
    if @board.flatten.include?(nil)
      false
    else
      true
    end
  end

  private

  def get_column_tokens(column_number)
    column = []
    @board.size.times do |num|
      current_token = @board[num][column_number]
      column << current_token unless current_token.nil?
    end
    column
  end

  def draw_row(row)
    # add pipe | in between each tile
    # #center helps with fixed spacing
    pipe_in_between = row.map { |v| "#{v.to_s.center(3) || ' '}" }.join('|')
    # adds bottom line(?) after each row
    "|#{pipe_in_between}|\n-----------------------------"
  end

  def draw_board_bottom
    numbers = ['➊', '➋', '➌', '➍', '➎', '➏', '➐']
    numbers_with_gaps = numbers.map { |num| "#{num.center(4)}" }
    puts " #{numbers_with_gaps.join('')}"
    # puts "haha"
  end

  def message_after_placement(shape, row_num, column_num)
    puts "placed #{shape} at row #{row_num}, column #{column_num}"
  end

  def red_text(text)
    "\e[31m#{text}\e[0m"
  end

  def blue_text(text)
    "\e[34m#{text}\e[0m"
  end

  def yellow_text(text)
    "\e[33m#{text}\e[0m"
  end
end

# stores player name and shape
class Player
  attr_reader :name, :shape

  def initialize(shape, name)
    @shape = shape
    @name = name
  end
end

# checks who wins
class Winchecker
  def initialize
    @winner = nil
    @win_combo = []
  end

  # 21/08
  def win_check(last_placed_token, current_player)
    # maybe need to go through everytile
    # after each placement
    return unless win_checK_all_direction(last_placed_token, current_player)

    puts "#{current_player.name} is the winner!"
    highlight_winning_tokens(last_placed_token)
    current_player

    # if row_check(last_placed_token) || column_check(last_placed_token) || diagnal_check(last_placed_token)
    #   return current_player
    # else
    #   nil
    # end
  end

  private

 

  # make sure these 3 methods update
  # winner variable and return true if
  # there is a winner

  def check_all_directions(row, column, board, row_delta, column_delta)
    possible_win_locations = (0..3).map { |num| [row + (num * row_delta), column + (num * column_delta)] }
    tokens = get_tokens_from_given_locations(possible_win_locations, board)
    # puts "#{row_delta}, #{column_delta}"
    four_of_same_tokens?(tokens)
  end

  def win_checK_all_direction(last_placed_token, _current_player)
    row = last_placed_token[0]
    column = last_placed_token[1]
    board = last_placed_token[3]

    directions = [
      [0, 1],   # →  Horizontal right
      [0, -1],  # ←  Horizontal left
      [1, 0],   # ↓  Vertical down
      [-1, 0],  # ↑  Vertical up
      [1, 1],   # ↘  Diagonal down-right
      [-1, -1], # ↖  Diagonal up-left
      [1, -1],  # ↙  Diagonal down-left
      [-1, 1]   # ↗  Diagonal up-right
    ]

    directions.any? { |row_delta, column_delta| check_all_directions(row, column, board, row_delta, column_delta) }
  end

  def get_tokens_from_given_locations(locations, board)
    tokens = []
    locations.each  do |location|
      # get_token prevents [] nomethoderror
      current_token = get_token(location, board)

      tokens << current_token unless current_token.nil?
    end

    tokens
  end

  def get_token(location, board)
    if board[location[0]].nil?
      nil
    elsif location[0] < 0 || location[1] < 0
      nil
    else
      @win_combo << [location[0], location[1]]
      # puts "#{location[0]}, #{location[1]}"
      board[location[0]][location[1]]
      # board[location[0]][location[1]] = 'd'

    end
  end

  def four_of_same_tokens?(tokens)
    # check tokens have 4 of same tokens
    if tokens.size == 4 && tokens.all?(tokens[0])
      true
    else
      false
    end
  end

  def highlight_winning_tokens(last_placed_token)
    board = last_placed_token[3]
    shape = last_placed_token[2]
    @win_combo[-4..@win_combo.size].each do |location|
      board[location[0]][location[1]] = yellow_text(shape.center(3))
    end
  end

  def yellow_text(text)
    "\e[33m#{text}\e[0m"
  end
end

game = ConnectFour.new
game.play_game
