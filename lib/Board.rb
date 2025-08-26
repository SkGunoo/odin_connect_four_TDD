class Board
  attr_reader :board, :last_placed_token_data

  def initialize(board_row = 4, board_column = 7)
    @board_row = board_row
    @board_column = board_column
    @board = Array.new(4) { Array.new(7) }
    # @last_placec_token gets pass to winchecker class
    # and the structure of it :[row,column,shape,@board]
    @last_placed_token_data = nil
  end


  def draw_board
    draw_column_numbers
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
      # skips iteration until token can reach 
      # the deepest it can go
      next unless @board[num][column].nil?
      # once it reaches the deepest row then
      # place the shape accoring to current player
      @board[num][column] = shape == '➀' ? red_text(shape.center(3)) : blue_text(shape.center(3))
      # update the @last_place_token with all
      # the data need to pass it to Wincheck class
      @last_placed_token_data = [num, column, shape, @board]
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
    # checks draw by flatten array and
    # look for a nil value if the board is full
    # there is no nil value
    if @board.flatten.include?(nil)
      false
    else
      true
    end
  end

  private
  # return a array of tokens of given
  # column. used for checking if a column is full
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

  def draw_column_numbers
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