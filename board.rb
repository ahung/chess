require_relative "piece"

class Board

  def initialize
    make_empty_board
  end

  def make_empty_board
    @board = Array.new(8) { Array.new(8, nil) }
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
    @board[end_pos[0], end_pos[1]] = nil
  end

  def move_piece(start_pos, end_pos)
    current_piece = @board[start_pos[0], start_pos[1]]
    if current_piece.move.include?([end_pos[0], end_pos[1]])
      if has_piece?([end_pos[0], end_pos[1]]) && enemy?
        capture(end_pos[0], end_pos[1])
      end
    end

  end

end

b = Board.new
rook = Rook.new([0,0], :black, b)
b[0, 0] = rook
b[0, 5] = Rook.new([0,5], :black, b)
p rook.moves