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

  def move

  end

end

b = Board.new
rook = Rook.new([0,0], :black, b)
b[0, 0] = rook
b[0, 5] = 1
p rook.moves