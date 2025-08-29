require_relative '../lib/Winchecker.rb'
describe Winchecker do
    describe '#win_check' do
      let(:win_checker) { described_class.new }
      let(:player) { double('Player', name: 'player') }
      
      context 'when there is a winning column' do
        it 'returns the winning player' do
          # Create any winning board scenario
          board = Array.new(4) { Array.new(7, nil) }
          # horizontal win
          (0..3).each { |i| board[0][i] = 'X' }  
          
          last_placed_data = [0, 0, 'X', board]
          
          result = win_checker.win_check(last_placed_data, player)
          expect(result).to eq(player)
        end
        
        it 'prints winner message' do
          board = Array.new(4) { Array.new(7, nil) }
          (0..3).each { |i| board[0][i] = 'X' }
          winning_message = "player is the winner!\n"
          last_placed_data = [0, 0, 'X', board]
          
          expect { win_checker.win_check(last_placed_data, player) }
            .to output(winning_message).to_stdout
        end
      end
      
      context 'when no win exists' do
        it 'returns nil' do
          board = Array.new(4) { Array.new(7, nil) }
          board[0][0] = 'X'  # Just one token, no win
          
          last_placed_data = [0, 0, 'X', board]
          
          result = win_checker.win_check(last_placed_data, player)
          expect(result).to be_nil
        end
      end
    end
end