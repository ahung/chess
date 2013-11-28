require_relative "piece"
require 'colorize'

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

    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    pieces.each_with_index do |piece_class, index|
      piece = piece_class.new([index, 0], :black, self)
      @board[index][0] = piece
    end

    #white
    (0..7).each do |index|
      pawn = Pawn.new([index, 6], :white, self)
      @board[index][6] = pawn
    end
    pieces.each_with_index do |piece_class, index|
      piece = piece_class.new([index, 7], :white, self)
      @board[index][7] = piece
    end
  end

  def to_s
    board_index_count = 0

    output = " a b c d e f g h"
    @board.each_index do |row_index|
      output += "\n#{8 - row_index}"
      @board.each_index do |col_index|
        if @board[col_index][row_index] == nil
          piece_text = "  "
        else
          piece_text = @board[col_index][row_index].to_s
        end

        #board background color
        if board_index_count.even?
          output += piece_text.colorize(:color => :blue,
                                        :background => :light_white )
        else
          output += piece_text.colorize(:color => :blue,
                                        :background => :light_black )
        end

        board_index_count += 1
      end
      board_index_count += 1
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
    if current_piece.valid_moves.include?(end_pos)
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
# king = King.new([0,0], :black, b)
# bishop = Bishop.new([0,1], :black, b)
# rook = Rook.new([0,5], :white, b)
# knight = Knight.new([1,2], :white, b)
#
# b[0, 0] = king
# b[0, 1] = bishop
# b[0, 5] = rook
# b[1, 2] = knight
#
# p b
# p bishop.valid_moves
# p king.valid_moves

