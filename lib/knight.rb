require_relative 'board'

# Knight with a starting and finishing point
class Knight
  attr_reader :start, :finish, :current, :queue, :chess_board, :result

  def initialize(start, finish)
    @start = start
    @finish = finish
    @chess_board = Board.new
    @result = []
  end

  # Accept a "parent" parameter which can be used to find target node's previous move
  def make_move(queue = [@start], parent = nil, target = @finish)
    @queue = queue
    @parent = parent
    @target = target
    @current = @queue.shift
    if @target == @start
      @result.unshift(@start)
    elsif (@queue.include? @target) || @current == @target
      target_found
    else
      possible_moves
    end
    print_result
  end

  # Add "target" to result array and run "make_move" method again to find find previous move
  def target_found
    @result.unshift(@target)
    @chess_board = Board.new
    make_move([@start], nil, @parent)
  end

  # Make all possible moves for each node. This function is called until target is reached.
  def possible_moves
    move_options = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
    (0..7).each do |i|
      if @chess_board.board.include? move(@current, move_options[i][0], move_options[i][1])
        @queue << move(@current, move_options[i][0], move_options[i][1])
        @chess_board.board.delete(move(@current, move_options[i][0], move_options[i][1]))
      end
    end
    make_move(@queue, @current, @target)
  end

  def move(location, x, y)
    location.map.with_index{ |num, index| index.zero? ? num + x : num + y }
  end

  def print_result
    puts "You made it in #{@result.length - 1} moves. Here's your path: #{@result}"
    exit
  end
end