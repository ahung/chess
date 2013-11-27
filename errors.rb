class EmptyStartPosError < StandardError
end

class InvalidEndPosError < StandardError
end


#for play method
begin
rescue EmptyStartPosError
  puts "No piece at that position."
rescue InvalidEndPosError
  puts "Not a valid move for that piece."
end