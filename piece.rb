class Piece
  attr_reader :moves, :pos, :color

  def initalize(pos, color)
    @pos = pos
    @color = color
  end

  def out_of_bounds?(move)
    (0..7).include?(move[0]) &&
    (0..7).include?(move[1])
  end

end




class SlidingPiece < Piece


  #come back to this (in board)
  def has_piece?(pos)
  end


  def moves
    all_moves = []

    @move_dirs.each do |dir|
        (1..8).each do |step|
        new_move = [ dir[0] * step, dir[1] * step ]
        all_moves << new_move unless out_of_bounds?(new_move)
        break if has_piece?(new_move)
        #currently will add occupied space into possible moves
      end
    end

    all_moves
  end

end

class Rook < SlidingPiece
  attr_reader :move_dirs

  def initialize
    @move_dirs = [ [1, 0] , [0, 1], [-1, 0], [0, -1] ]
  end

end