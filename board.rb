class Board

  def initialize
    make_empty_board
  end

  def make_empty_board
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    self[pos] = piece
  end

  def has_piece?(pos)
    x, y = pos

  end

end

b = Board.new
p b[[0, 0]]
b[0, 0] = 1
#p b[[0, 0]]

# def [](x, y)
#   @board[x][y]
# end