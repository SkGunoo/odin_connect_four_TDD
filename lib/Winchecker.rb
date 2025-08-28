class Winchecker
  def initialize
    @winner = nil
    @win_combo = []
  end

  # 21/08
  def win_check(last_placed_token_data, current_player)
    
    #retuns nothing if there is no winner
    return unless win_checK_all_direction(last_placed_token_data, current_player)

    puts "#{current_player.name} is the winner!"
    highlight_winning_tokens(last_placed_token_data)
    current_player

    # if row_check(last_placed_token_data) || column_check(last_placed_token_data) || diagnal_check(last_placed_token_data)
    #   return current_player
    # else
    #   nil
    # end
  end

  private

 

  # make sure these 3 methods update
  # winner variable and return true if
  # there is a winner

  
  # check if last placed token 
  def win_checK_all_direction(last_placed_token_data, _current_player)
    # last_placed_token_data has data 
    # [row,column,shape,@board]
    row = last_placed_token_data[0]
    column = last_placed_token_data[1]
    board = last_placed_token_data[3]

    # array of index offset values for each directions
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
    # retunrs true or false depends of result of #check_all_directions
    directions.any? { |row_delta, column_delta| check_all_directions(row, column, board, row_delta, column_delta) }
  end

  def check_all_directions(row, column, board, row_delta, column_delta)
    (-3..0).any? do |offset|
      #creates array of locations based on row and column using row_delta and column_delta
      possible_win_locations = (0..3).map { |num| [row + ((num + offset) * row_delta), column + ((num + offset) * column_delta)] }
      #get the tokens from given locations in array form
      tokens = get_tokens_from_given_locations(possible_win_locations, board)
      #return true if tokens consist of 4 of same tokens
      four_of_same_tokens?(tokens)
    end
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
    #this prevents negative indexing which could
    #result wrong sequence of tokens as winner
    elsif location[0] < 0 || location[1] < 0
      nil
    else
      @win_combo << [location[0], location[1]]
      board[location[0]][location[1]]

    end
  end

  def four_of_same_tokens?(tokens)
    # check tokens have 4 of same tokens
    # tokens[0] is the last_place_token
    if tokens.size == 4 && tokens.all?(tokens[0])
      true
    else
      false
    end
  end
  # highlight the winning tokens by 
  # change the token colours to yellow
  def highlight_winning_tokens(last_placed_token_data)
    board = last_placed_token_data[3]
    shape = last_placed_token_data[2]
    @win_combo[-4..@win_combo.size].each do |location|
      board[location[0]][location[1]] = yellow_text(shape.center(3))
    end
  end

  def yellow_text(text)
    "\e[33m#{text}\e[0m"
  end
end