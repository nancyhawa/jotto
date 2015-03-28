require_relative 'wordlist'
require 'pry'

def gameplay
	playernum
end

def playernum
	puts "Welcome to JOTTO!"
	puts "Would you like to play on your own or compete against me?"
	puts "Enter '1' for a one player game or '2' to play agaist me."
	players = gets.chomp
	if players == "1"
		one_player
	elsif players == "2"
		two_player
	else 
		puts "I didn't understand your response.  Would you like to play against the computer or against a friend?"
		puts "Enter '1' for a one player game or '2' for a 2 player game."
		playernum
	end
end

def one_player
	guess_list = Hash.new

	puts "I will choose a five letter word, and you must guess it."
	puts "Every time you guess, I will tell you how many letters your word has in common with mine."

	computer_word = random_word(word_sort)
	play_list = word_sort

  #This is looping, but not breaking when the player declines a rematch.
  rematch_decline = false
  until rematch_decline
    turn(computer_word, guess_list, play_list, rematch_decline)
  end
end

def two_player
	guess_list = Hash.new

	computer_word = random_word(word_sort)
	narrow_list = word_sort
  play_list = word_sort

	puts "You think you can beat me?  Highly unlikely."
	puts "I'll give you a head start. You go first!"
 
	rematch_decline = false
	until rematch_decline
		turn(computer_word, guess_list, play_list, rematch_decline)
		narrow_list = computer_turn(narrow_list, rematch_decline, play_list, computer_word)
	end
end

def rematch(guess_list)
  puts "Great game!"
  puts "Would you like a rematch? Answer 'Yes' or 'No'."
  play_again = gets.chomp.downcase
  if play_again == "yes"
    guess_list.clear
    gameplay
  elsif play_again == "no"
    puts "Have a great day!  I hope you had fun!"
    puts "End of Game"
    return true
  else 
    puts "I don't understand that response."
    rematch(guess_list)
  end
end

def word_sort
	game_list = []

	word_list.each do |x|
		if x.length == 5 && repeat_letters?(x) == false
			game_list.push(x)
		end
	end
	return game_list
end

def random_word(array)
	return array[rand(array.length - 1)]
end

def turn(computer_word, guess_list, play_list, rematch_decline)

	sorted_list = word_sort

	puts "Guess a five letter word."
	guess = gets.chomp

	if guess.downcase == computer_word.downcase
		puts "You won!  Congratulations"
    rematch(guess_list)
  elsif guess.downcase == "give up"
    puts "That is super lame.  For real."
    puts "My word was #{computer_word.upcase}."
    rematch(guess_list)
	elsif guess.downcase == "view"
		guess_list.each do |key, value|
			puts "#{key.upcase}: #{value}"
		end
		turn(computer_word, guess_list, play_list, rematch_decline)
  elsif guess.length != 5
    puts "Make sure your word has 5 letters!"
    turn(computer_word, guess_list, play_list, rematch_decline)
  elsif repeat_letters?(guess) == true
    puts "Make sure your guess has no repeat letters."
    turn(computer_word, guess_list, play_list, rematch_decline)
	elsif play_list.include?(guess) == false
		puts "Sorry!  That is not a word!"
		turn(computer_word, guess_list, play_list, rematch_decline)
	else
		value = compare(computer_word,guess)
		puts "#{guess.upcase}: #{value}"
		add_to_hash(guess,value, guess_list)
	end
end

def add_to_hash(guess,value, guess_list)
	guess_list[guess] = value
end

def repeat_letters?(word)
	x = 0
	while x < word.split(//).length - 1
		return true if word.split(//).count(word.split(//)[x]) > 1
		x += 1
	end
	return false
end

def compare(word1, word2)
	count = 0
	word1.downcase.split("").each do |letter|
		count += 1 if word2.downcase.split("").include?(letter)
	end
	return count
end

def computer_turn(narrow_list, rematch_decline, play_list, computer_word)

	computer_guess = random_word(narrow_list) 

	puts "My turn."
	puts "My guess is #{computer_guess.upcase}."

	response = gets.chomp

	if response == "view"
		puts narrow_list[100...110]
		puts "My next guess is #{computer_guess.upcase}"
		response = gets.chomp
	elsif [0, 1, 2, 3, 4, 5].include?(response.to_i) != true
		puts "That is not a valid response.  Your response must be an integer between 0 and 5."
		puts "My guess was #{computer_guess.upcase}"
		response = gets.chomp
	elsif response.to_i == 5
		puts "Was that the word?  Answer Y or N."
		answer = gets.chomp.downcase
		if answer == "y"
			puts "I win!  I told you I would."
			puts "My word was #{computer_word.upcase}"
			rematch(guess_list)
		else 
			puts "Ok.  I'm close though.  Not many options."
			refine_list(narrow_list, computer_guess, response.to_i)
		end
	else
		refine_list(narrow_list, computer_guess, response.to_i)
	end
end

def refine_list(array, guess, letters_in_common)	
	array = array - [guess]
	array.each do | word |
		if compare(word, guess) != letters_in_common
		 	array = array - [word]
		end
	end
	puts "#{array.length} words now."
	return array
end

gameplay
