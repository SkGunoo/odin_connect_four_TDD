require_relative '../lib/Board.rb'


describe Board do
  describe '#draw_board' do
    subject(:game_board) { described_class.new }
    
    context 'when board is empty' do
      it 'displays the empty board and executes puts 6 times' do
        # Count the puts calls but still allow them to print
        # allow() lets the real method run while still counting calls
        expect(game_board).to receive(:puts).exactly(2).times.and_call_original
        
        puts "\n=== YOUR BOARD OUTPUT ==="
        game_board.draw_board  # This will now print to the terminal
        puts "=== END OF BOARD OUTPUT ===\n"
      end
    end

    context 'when there some tokens in the board' do
      it 'displays board with some tokens' do
        board = game_board.board
        board[0][1] = '➁'
        board[1][2] = '➀'

        expect(game_board).to receive(:puts).exactly(2).times.and_call_original
        
        puts "\n=== YOUR BOARD OUTPUT ==="
        game_board.draw_board  # This will now print to the terminal
        puts "=== END OF BOARD OUTPUT ===\n"
      end
    end
  end

  describe '#place_token_to_column' do
    subject(:game_board) { described_class.new }

    before do
      allow(game_board).to receive(:puts)
      # allow(game_board.red_text).to receive('x').and_return('x')
      
    end
    context 'when user place a token in empty board' do 
      it 'place a token in row 0 column 0 ' do
        board = game_board.board
        # priave #red_text ets applied to shape
        # once its placed on the board
        shape = 'x'
        shape_after_placed = "\e[34m x \e[0m"


        game_board.place_token_to_column(0,shape)
        expect(board[0][0]).to eq(shape_after_placed)
      end

      it 'place a token at row 1 column 0' do
        board = game_board.board
        shape = 'x'
        shape_after_placed = "\e[34m x \e[0m"
        
        game_board.place_token_to_column(0,shape)

        game_board.place_token_to_column(0,shape)
        expect(board[1][0]).to eq(shape_after_placed)
      end
    end
  end

  describe '#not_full' do
    subject(:game_board) { described_class.new }
    let(:empty_column) {[]}
    let(:half_filled_column) {['o','x']}
    let(:full_column) {['o','x','x','o']}
    before do
      # allow(game_board).to receive(:get_column_tokens).and_return([])

      #setting @board_row variable
      game_board.instance_variable_set(:@board_row, 4)
    end
    context 'when the column is empty' do 
      
      it 'return true ' do
        allow(game_board).to receive(:get_column_tokens).and_return(empty_column)
        expect(game_board.not_full?(1)).to be(true)
      end

      # it 'does not puts out a message' do
      #   expect{game_board.not_full?(1)}.not_to output.to_stdout
      # end
    end

    context 'when the column is half full' do
      it 'return true ' do
        allow(game_board).to receive(:get_column_tokens).and_return(half_filled_column)
        expect(game_board.not_full?(1)).to be(true)

      end
    end

    context 'when the column is full' do
      it 'return false and puts "that column is full!"' do
        allow(game_board).to receive(:get_column_tokens).and_return(full_column)
        expect(game_board.not_full?(1)).to be(false)
        expect{game_board.not_full?(1)}.to output("that column is full!\n").to_stdout

      end
    end


  end

  describe '#draw_check' do
    subject(:game_board) {described_class.new}
    let(:board_full_of_nil) {[[nil,nil,nil],[nil,nil,nil]]}
    let(:board_with_one_nil) {[['o','x','o'],['x','o',nil]]}
    let(:board_with_no_nil) {[['o','x','o'],['x','o','o']]}
    

    context 'when the board is full of nil' do
      before do 
        game_board.instance_variable_set(:@board, board_full_of_nil)
      end

      it "returns false" do
        expect(game_board.draw_check).to eq(false)
      end
    end

    context 'when the board has one nil' do
      before do 
        game_board.instance_variable_set(:@board, board_with_one_nil)
      end

      it "returns false" do
        expect(game_board.draw_check).to eq(false)
      end
    end

    context 'when the board has no nil' do
      before do 
        game_board.instance_variable_set(:@board, board_with_no_nil)
      end

      it "returns true" do
        expect(game_board.draw_check).to eq(true)
      end
    end
  end

end