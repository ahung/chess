require_relative "piece"

class Board

  def initialize
    make_empty_board
  end

  def make_empty_board
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def to_s
    output = ""
    @board.each_index do |row_index|
      @board.each_index do |col_index|
        if @board[col_index][row_index] == nil
          output += "_"
        else
          output += @board[col_index][row_index].to_s
        end
      end
      output += "\n"
    end
    output
  end

  def [](x,y)
    @board[x][y]
  end

  def []=(x,y, piece)
    @board[x][y] = piece
  end

  def has_piece?(pos)
    x, y = pos
    !@board[x][y].nil?
  end

  def capture(x, y)
    @board[x][y] = nil
  end

  def move_piece(start_pos, end_pos)
    current_piece = @board[start_pos[0]][start_pos[1]]
    p end_pos
    if current_piece.moves.include?(end_pos)
      if has_piece?(end_pos)
        capture(end_pos[0], end_pos[1])
      end
      current_piece.moved = true if current_piece.class == Pawn
      @board[end_pos[0]][end_pos[1]] = current_piece
      current_piece.pos = end_pos
      @board[start_pos[0]][start_pos[1]] = nil
    end
  end
end

b = Board.new
q = Rook.new([3,1], :white, b)
# p q.moves
b[3, 1] = q
# b[3, 4] = Knight.new([3,4], :white, b)
# p b
# b.move_piece([2, 3], [3, 4])
# p b
pawn = Pawn.new([4, 0], :black, b)
b[4, 0] = pawn
p pawn.moves
p b
b.move_piece([4, 0], [3, 1])
p pawn.moves
p b