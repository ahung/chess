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

class Rook < SlidingPiece
  attr_reader :move_dirs

  def initialize(pos, color, board)
    super(pos, color, board)
    @move_dirs = [ [1, 0] , [0, 1], [-1, 0], [0, -1] ]
  end

end