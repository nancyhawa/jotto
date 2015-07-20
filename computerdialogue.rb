class ComputerResponses
	def initialize
		@rematch = rematch
		@no_words_error = no_words_error
	end


	def rematch
	  puts "Great game!"
	  puts "Would you like a rematch? Answer 'Yes' or 'No'."
	  play_again = gets.chomp.downcase
	  if play_again == "yes"
	    gameplay
	  elsif play_again == "no"
	    puts "Have a great day!  I hope you had fun!"
	    abort("END OF GAME")
	  else 
	    puts "I don't understand that response."
	    rematch
	  end
	end

	def no_words_error(play_list, computer_word, computer_guess_list)
	puts "One of us must have made a mistake."
	puts "I don't think there are any words that match the parameters you've given me."
	puts "What is your word?"
	user_word = gets.chomp.downcase

	if user_word.length != 5
    	puts "Your word didn't have five letters!  That's why I got confused."
  	elsif user_word.repeat_letters? == true
    	puts "Whoops!  Your word had a letter that repeated.  That why I got confused!"
	elsif play_list.include?(user_word) == false
		puts "Sorry!  That word isn't in my dictionary.  That's why I got confused!"
	else
		puts "You made some errors."		
		computer_guess_list.each do |key, value|
			if compare(user_word, key) != value.to_i
				puts "You told me that your word had #{value} letters in common with #{key.upcase}."  
				puts "Actually, it has #{compare(user_word, key)} letters in common." 
			end
		end
	end

	puts "My word was #{computer_word.upcase}."

	rematch
	end
end