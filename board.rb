require_relative "piece"

class Board
  attr_reader :board

  def initialize
    make_empty_board
  end

  def make_empty_board
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def populate_board
    #black
    (0..7).each do |index|
      pawn = Pawn.new([index, 1], :black, self)
      @board[index][1] = pawn
    end
    rook = Rook.new([0, 0], :black, self)
    @board[0][0] = rook
    rook = Rook.new([7, 0], :black, self)
    @board[7][0] = rook
    knight = Knight.new([1, 0], :black, self)
    @board[1][0] = knight
    knight = Knight.new([6, 0], :black, self)
    @board[6][0] = knight
    bishop = Bishop.new([2, 0], :black, self)
    @board[2][0] = bishop
    bishop = Bishop.new([5, 0], :black, self)
    @board[5][0] = bishop
    queen = Queen.new([3, 0], :black, self)
    @board[3][0] = queen
    king = King.new([4, 0], :black, self)
    @board[4][0] = king
    #white
    (0..7).each do |index|
      pawn = Pawn.new([index, 6], :white, self)
      @board[index][6] = pawn
    end
    rook = Rook.new([0, 7], :white, self)
    @board[0][7] = rook
    rook = Rook.new([7, 7], :white, self)
    @board[7][7] = rook
    knight = Knight.new([1, 7], :white, self)
    @board[1][7] = knight
    knight = Knight.new([6, 7], :white, self)
    @board[6][7] = knight
    bishop = Bishop.new([2, 7], :white, self)
    @board[2][7] = bishop
    bishop = Bishop.new([5, 7], :white, self)
    @board[5][7] = bishop
    queen = Queen.new([3, 7], :white, self)
    @board[3][7] = queen
    king = King.new([4, 7], :white, self)
    @board[4][7] = king
  end

  def to_s
    output = " abcdefgh"
    @board.each_index do |row_index|
      output += "\n#{8 - row_index}"
      @board.each_index do |col_index|
        if @board[col_index][row_index] == nil
          output += "\u25A1"
        else
          output += @board[col_index][row_index].to_s
        end
      end
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
    if current_piece.moves.include?(end_pos)
      if has_piece?(end_pos)
        capture(end_pos[0], end_pos[1])
      end
      current_piece.moved = true if current_piece.class == Pawn
      @board[end_pos[0]][end_pos[1]] = current_piece
      current_piece.pos = end_pos
      @board[start_pos[0]][start_pos[1]] = nil
    else
      raise InvalidEndPosError.new
    end
  end

  def move!(start_pos, end_pos)
    current_piece = @board[start_pos[0]][start_pos[1]]
    @board[end_pos[0]][end_pos[1]] = current_piece
    @board[start_pos[0]][start_pos[1]] = nil
    current_piece.pos = end_pos
  end

  def in_check?(color)
    king_pos = get_pieces(color, King)[0].pos
    enemy_color = color == :white ? :black : :white

    enemy_pieces = get_pieces(enemy_color)

    enemy_pieces.each do |enemy_piece|
      return true if enemy_piece.moves.include?(king_pos)
    end
    false
  end

  def checkmate?(color)
    if in_check?(color)
      get_pieces(color).each do |piece|
        return false if piece.valid_moves.any?
      end
      return true
    end
    false
  end

  def get_pieces(color, piece_class = nil)
    pieces = @board.flatten.compact.select do |piece|
      (piece_class.nil? || piece.class == piece_class) &&
      piece.color == color
    end
  end

  def dup
    new_board = Board.new
    new_board.board.each_index do |row_index|
      new_board.board[row_index].each_index do |col_index|
        next if @board[row_index][col_index].nil?
        current_piece = @board[row_index][col_index]
        new_piece = current_piece.class.new(current_piece.pos.dup,
                                            current_piece.color,
                                            new_board)
        new_board.board[row_index][col_index] = new_piece
      end
    end
    new_board
  end
end

# b = Board.new
# b.populate_board
# b.move_piece([5, 6], [5, 5])
# b.move_piece([4, 1], [4, 3])
# b.move_piece([6, 6], [6, 4])
# b.move_piece([3, 0], [7, 4])
# p b
# p b.checkmate?(:white)

