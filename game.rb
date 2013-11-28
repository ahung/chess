require_relative 'board'
require_relative 'errors'
require 'colorize'

class Game

  def initialize
    @board = Board.new
    @board.populate_board
    @current_player = :white
  end

  def play

    until @board.checkmate?(:black) || @board.checkmate?(:white)
      puts "\e[H\e[2J"
      p @board
      puts "Check" if @board.in_check?(@current_player)
      begin
        play_turn
        swap_turn
      rescue InvalidInputError
        puts "Please enter a valid move"
        retry
      rescue WrongColorError
        puts "Please move your own pieces."
        retry
      rescue EmptyStartPosError
        puts "No piece at that position."
        retry
      rescue InvalidEndPosError
        puts "Not a valid move for that piece."
        retry
      end
    end

    puts "Checkmate!"
    puts "White wins" if @board.checkmate?(:black)
    puts "Black wins" if @board.checkmate?(:white)
  end

  def convert_move(x, y)
    x_coord = ("a".."h").to_a.index(x)
    y_coord = 8 - y.to_i
    [x_coord, y_coord]
  end


  def play_turn
    puts "#{@current_player}'s turn:"
    puts "What move would you like to make?"
    input = gets.chomp.gsub(" ", "")
    match = /[a-h][1-8],[a-h][1-8]/.match(input)
    raise InvalidInputError.new if match.nil?
    input = input.split(',')
    start_pos = convert_move(input[0][0], input[0][1])
    end_pos = convert_move(input[1][0], input[1][1])
    current_piece = @board[start_pos[0], start_pos[1]]

    raise EmptyStartPosError.new if current_piece.nil?

    unless current_piece.color == @current_player
      raise WrongColorError.new "wrong color error msg"
    end

    @board.move_piece(start_pos, end_pos)
  end

  def swap_turn
    @current_player == :white ?
      @current_player = :black : @current_player = :white
  end


end

game = Game.new
game.play