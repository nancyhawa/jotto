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
		puts "I didn't understand your response.  Would you like to play against 
		the computer or on your own."
		puts "Enter '1' for a one player game or '2' for a 2 player game."
		playernum
	end
end

def one_player
	guess_list = Hash.new

	puts "I will choose a five letter word, and you must guess it."
	puts "Every time you guess, I will tell you how many letters your word has 
	in common with mine."

	computer_word = random_word(word_sort)
	play_list = word_sort

  #This is looping, but not breaking when the player declines a rematch.
  until false
    turn(computer_word, guess_list, play_list, rematch_decline)
  end
end

def two_player
	guess_list = Hash.new
	computer_guess_list = Hash.new

	computer_word = random_word(word_sort)
	narrow_list = word_sort
  	play_list = word_sort

	puts "You think you can beat me?  Highly unlikely."
	puts "I'll give you a head start. You go first!"
 
	
	until false
		turn(computer_word, guess_list, play_list)
		narrow_list = computer_turn(narrow_list, play_list, 
			computer_word, computer_guess_list)
	end
end

#I want this to break out of the loop if the answer is no, but I can't figure that ou
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

def turn(computer_word, guess_list, play_list)

	sorted_list = word_sort

	puts "Guess a five letter word."
	guess = gets.chomp

	if guess.downcase == computer_word.downcase
		puts "You won!  Congratulations"
    rematch
  elsif guess.downcase == "give up"
    puts "That is super lame.  For real."
    puts "My word was #{computer_word.upcase}."
    rematch
	elsif guess.downcase == "view"
		guess_list.each do |key, value|
			puts "#{key.upcase}: #{value}"
		end
		turn(computer_word, guess_list, play_list)
  elsif guess.length != 5
    puts "Make sure your word has 5 letters!"
    turn(computer_word, guess_list, play_list)
  elsif repeat_letters?(guess) == true
    puts "Make sure your guess has no repeat letters."
    turn(computer_word, guess_list, play_list)
	elsif play_list.include?(guess) == false
		puts "Sorry!  That is not a word!"
		turn(computer_word, guess_list, play_list)
	else
		value = compare(computer_word,guess)
		puts "#{guess.upcase}: #{value}"
		add_to_hash(guess,value, guess_list)
	end
end

def add_to_hash(guess, value, hash)
	hash[guess] = value
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

def computer_turn(narrow_list, play_list, computer_word, computer_guess_list)

	computer_guess = random_word(narrow_list) 

	puts "My turn."
	puts "My guess is #{computer_guess.upcase}."

	response = gets.chomp

	if response == "view"
		puts narrow_list[100...110]
		puts "My next guess is #{computer_guess.upcase}"
		response = gets.chomp
	#I need to throw an error for a single letter response.
	elsif [0, 1, 2, 3, 4, 5].include?(response.to_i) != true or response.length > 1
		puts "That is not a valid response.  Your response must be an integer 
		between 0 and 5."
		puts "My guess was #{computer_guess.upcase}"
		response = gets.chomp
	elsif response.to_i == 5
		puts "Was that the word?  Answer Y or N."
		answer = gets.chomp.downcase
		if answer == "y"
			puts "I win!  I told you I would."
			puts "My word was #{computer_word.upcase}"
			rematch
		else 
			puts "Ok.  I'm close though.  Not many options."
			add_to_hash(computer_guess, response, computer_guess_list)
			refine_list(narrow_list, computer_guess, response.to_i, play_list, computer_word, computer_guess_list)
		end
	else
		add_to_hash(computer_guess, response, computer_guess_list)
		refine_list(narrow_list, computer_guess, response.to_i, play_list, computer_word, computer_guess_list)
	end
end

def refine_list(array, guess, letters_in_common, play_list, computer_word, computer_guess_list)	
	array = array - [guess]
	array.each do | word |
		if compare(word, guess) != letters_in_common
		 	array = array - [word]
		end
	end
	puts "#{array.length} words now."
	if array.length == 0
		no_words_error(play_list, computer_word, computer_guess_list)
	else
		return array
	end
end

def no_words_error(play_list, computer_word, computer_guess_list)
	puts "One of us must have made a mistake."
	puts "I don't think there are any words that match the parameters you've given me."
	puts "What is your word?"
	user_word = gets.chomp.downcase

	if user_word.length != 5
    	puts "Your word didn't have five letters!  That's why I got confused."
  	elsif repeat_letters?(user_word) == true
    	puts "Whoops!  Your word had a letter that repeated.  That why I got confused!"
	elsif play_list.include?(user_word) == false
		puts "Sorry!  That word isn't in my dictionary.  That's why I got confused!"
	else
		puts "You made some errors."		
		computer_guess_list.each do |key, value|
		#This is printing the puts statements for all guess and not just the ones that were answered inaccurately.
			if compare(user_word, key) != value
				puts "You told me that your word had #{value} letters in common with #{key.upcase}."  
				puts "Actually, it has #{compare(user_word, key)} letters in common." 
			end
		end
	end

	puts "My word was #{computer_word.upcase}."

	rematch
end



gameplay
