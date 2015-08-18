class Rematch

	def run
	  puts "Great game!"
	  puts "Would you like a rematch? Answer 'Yes' or 'No'."
	  @play_again = gets.chomp.downcase
	  if @play_again == "yes"
	    JottoGame.new.run
	  elsif @play_again == "no"
	    puts "Have a great day!  I hope you had fun!"
	    abort("END OF GAME")
	  else
	    puts "I don't understand that response."
	    Rematch.new.run
	  end
	end

end
