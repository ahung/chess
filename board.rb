require_relative "piece"
require_relative "errors"

class Board
  attr_reader :board

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
    raise EmptyStartPosError.new if current_piece.nil?
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

  def in_check?(color)
    king_pos = get_pieces(color, King)[0].pos
    enemy_color = color == :white ? :black : :white

    enemy_pieces = get_pieces(enemy_color)

    enemy_pieces.each do |enemy_piece|
      return true if enemy_piece.moves.include?(king_pos)
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
          #@board[row_index][col_index].clone
      end
    end
    new_board
  end

end

b = Board.new
q = Queen.new([3, 3], :white, b)
b[3, 3] = q
king = King.new([5, 4], :black, b)
b[5, 4] = king
p b
p king.moves
p king.valid_moves


