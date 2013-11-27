require 'debugger'

class Piece
  attr_accessor :pos
  attr_reader :moves, :color

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
      step = 1
      new_move = [ pos[0] + (dir[0] * step), pos[1] + (dir[1] * step) ]

      while in_bounds?(new_move)
        if @board.has_piece?(new_move)
          #target move has enemy piece
          if @color != @board[new_move[0], new_move[1]].color
            all_moves << new_move
          end
          break
        end

        all_moves << new_move
        step += 1
        new_move = [ pos[0] + (dir[0] * step), pos[1] + (dir[1] * step) ]
      end
    end
    all_moves
  end
end

#knights, king
class SteppingPiece < Piece
  def moves
    all_moves = []

    @move_dirs.each do |dir|
      new_move = [pos[0] + dir[0], pos[1] + dir[1]]
      next unless in_bounds?(new_move)
      unless @board.has_piece?(new_move) &&
             @color == @board[new_move[0], new_move[1]].color
        all_moves << new_move
      end
    end

    all_moves
  end
end

class Rook < SlidingPiece

  def initialize(pos, color, board)
    super
    @move_dirs = [ [1, 0] , [0, 1], [-1, 0], [0, -1] ]
  end

  def to_s
    "R"
  end
end

class Bishop < SlidingPiece

  def initialize(pos, color, board)
    super
    @move_dirs = [ [1, 1] , [-1, 1], [-1, -1], [1, -1] ]
  end

  def to_s
    "B"
  end
end

class Queen < SlidingPiece

  def initialize(pos, color, board)
    super
    @move_dirs = [ [1, 1] , [-1, 1], [-1, -1], [1, -1],
                   [1, 0] , [0, 1], [-1, 0], [0, -1] ]
  end

  def to_s
    "Q"
  end
end

class King < SteppingPiece

  def initialize(pos, color, board)
    super
    @move_dirs = [ [1, 1] , [-1, 1], [-1, -1], [1, -1],
                   [1, 0] , [0, 1], [-1, 0], [0, -1] ]
  end

  def to_s
    "M"
  end
end

class Knight < SteppingPiece

  def initialize(pos, color, board)
    super
    @move_dirs = [ [2, 1], [1, 2], [-1, 2], [-2, 1],
                   [-2, -1], [-1, -2], [1, -2], [2, -1]]
  end

  def to_s
    "K"
  end
end