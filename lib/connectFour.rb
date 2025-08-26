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

  # play a round of connect 4 game
  # until someone wins or game draw
  def play_game
    until @game_draw || @winner
      column = ask_for_column
      @board.place_token_to_column(column, @current_player.shape)
      @winner = @win_checker.win_check(@board.last_placed_token_data, @current_player)
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

  # ask user to choose a column to
  # place a token 
  # displays current status of the board 
  # before asking
  def ask_for_column
    @board.draw_board
    puts 'current board layout ↑ '
    ask_for_number
  end

  # ask user until user type
  # number between (1 ~ 7)
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

  # switches player after a turn
  def switch_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def draw_board
    @board.draw_board
  end
end