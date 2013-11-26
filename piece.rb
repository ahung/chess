require 'debugger'

class Piece
  attr_reader :moves, :pos, :color

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def in_bounds?(move)
    (0..7).include?(move[0]) &&
    (0..7).include?(move[1])
  end

end




class SlidingPiece < Piece

  def moves
    all_moves = []

    @move_dirs.each do |dir|
      (1..7).each do |step|
        #debugger
        new_move = [ dir[0] * step, dir[1] * step ]
        all_moves << new_move if in_bounds?(new_move)
        break if @board.has_piece?(new_move)
        #currently will add occupied space into possible moves
      end
    end

    all_moves
  end

end

class Rook < SlidingPiece
  attr_reader :move_dirs

  def initialize(pos, color, board)
    super(pos, color, board)
    @move_dirs = [ [1, 0] , [0, 1], [-1, 0], [0, -1] ]
  end

end