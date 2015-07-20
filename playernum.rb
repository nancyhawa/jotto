def playernum?
	puts "Would you like to play on your own or compete against me?"
	puts "Enter '1' for a one player game or '2' to play agaist me."
	
	players = gets.chomp
	if players == "1"
		one_player
	elsif players == "2"
		two_player
	else 
		puts "I didn't understand your response.  Would you like to play against 
		the computer or on your own."
		puts "Enter '1' for a one player game or '2' for a 2 player game."
		playernum?
	end
end

def one_player
	#guess_list is a hash that stores the player's guesses and the no. of letters they have 
	#in common with the computer's word
	guess_list = Hash.new

	puts "I will choose a five letter word, and you must guess it."
	puts "Every time you guess, I will tell you how many letters your word has 
	in common with mine."

	#play_list is a list of all valid words for use in the game.
	#Right now it is the full dictionary, whittled down to 5 letter words with no repeats.
	#Eventually, I want to build out the game so it is playable with 4 and 6 letter words.
	play_list = word_sort(word_list)

  #This works, but doesn't really read in a sensible way.
  until false
    turn(computer_word, guess_list, play_list)
  end
end

def two_player
	#guess_list is a hash that stores the player's guesses and the #of letters they have 
	#in common with the computer's word
	guess_list = Hash.new

	#computer_guess_list is a hash that stores the computer's guesses and the #of letters 
	#they have in common with the player's word
	computer_guess_list = Hash.new

	#narrow_list starts as a list of all valid words for use in the game, but as the 
	#computer gets more information, it deletes words from the list, "narrowing" it down
	#to the users word.
	narrow_list = word_sort(word_list)
  	
	puts "You think you can beat me?  Highly unlikely."
	puts "I'll give you a head start. You go first!"
 
	#Again, I don't think this code is "readable" but it works. 
	until false
		turn(computer_word, guess_list, play_list)
		narrow_list = computer_turn(narrow_list, play_list, 
			computer_word, computer_guess_list)
	end
end
