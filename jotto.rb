require_relative 'wordlist'
require_relative 'comp_choice_list'
require 'pry'

def gameplay
	puts "Welcome to JOTTO!"
	directions?
	playernum
end

def directions?
	puts "Would you like me to review the rules of the game?"
	puts "Type 'Y' if yes and 'N' if you are ready to play without any instructions."

	example = Hash.new

	example["LIGHT"] = 2
	example["RIGHT"] = 3

	answer = gets.chomp.downcase
	if answer == "y"
		puts "The goal of this game is for you to guess the five letter word of my choosing"
		puts "My word will be exactly five letters long, and it will have no repeat letters."
		puts "For example, 'FUNNY' would not be a valid word because it contains two N's."
		puts "'TOTES would also be invalid because there are two T's, even though the T's are not consecutive."
		puts "In order to figure out my word, you will guess a five letter word."
		puts "I will tell you how many letters it has in common with mine."
		puts "The order of the letters does not matter."
		puts "Let me give you an example."
		puts "Let's say your first guess was 'LIGHT' and I told you it had two letters."
		puts "Then you guess 'RIGHT' and I tell you it has three letters."
		puts "You can be certain that there is an R somewhere in the word, because the count went up when you added only an R."
		puts "However, you cannot know whether the R is the first letter."
		puts "You can also be certain that there is no 'L' in the word."
		puts "Whenever it is your turn to guess a word, you can type the word 'view' instead, and you will get a list of all the words you have guessed."
		puts "This is how it will look."

		example.each do |key, value|
			puts "#{key.upcase}: #{value}"
		end

		puts "You can also play against me.  You will come up with a word as well, and I will try to figure it out."
		puts "We will take turns guessing, telling eachother how many letters those guesses have in common with our words."
		puts "Whoever figures out the other players word first wins."
		puts "Realistically, you are going to lose.  But you can try."
	end
end

def playernum
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

# def num_letters
# 	letters = gets.chomp
# end

def one_player
	#guess_list is a hash that stores the player's guesses and the no. of letters they have 
	#in common with the computer's word
	guess_list = Hash.new

	puts "I will choose a five letter word, and you must guess it."
	puts "Every time you guess, I will tell you how many letters your word has 
	in common with mine."

	computer_word = random_word(word_sort(compwordlist))

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

	computer_word = random_word(word_sort(compwordlist))

	#play_list is a list of all valid words for use in the game.
	play_list = word_sort(word_list)

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

def word_sort(wordlist)
	play_list = []

	wordlist.each do |x|
		if x.length == 5 && repeat_letters?(x) == false
			play_list.push(x)
		end
	end
	return play_list
end

def random_word(array)
	return array[rand(array.length - 1)]
end

def turn(computer_word, guess_list, play_list)

	sorted_list = word_sort(word_list)

	puts "Guess a five letter word."
	guess = gets.chomp

  if guess.downcase == computer_word.downcase
		puts "You won!  Congratulations"
    rematch
  elsif guess_list.has_key?(guess)
  	puts "You already guessed that word."
  	puts "#{guess.upcase}: #{guess_list[guess]}"
  	turn(computer_word, guess_list, play_list)
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

	computer_guess_method(narrow_list, play_list, computer_word, computer_guess_list, computer_guess)
end

#I separated out this method to deal with an error I was getting when a player guessed
#a word out of turn.	
def computer_guess_method(narrow_list, play_list, computer_word, computer_guess_list, computer_guess)

	response = gets.chomp

	#I need to throw an error for a single letter response.
	#When the player types a word instead of a response, it thows the correct error, and then 
	#it asks the player again, but then the next guess is the player's last response.
	#I don't know why the response becomes the list to choose from.
	if [0, 1, 2, 3, 4, 5].include?(response.to_i) != true or response.length > 1
		puts "That is not a valid response.  Your response must be an integer 
		between 0 and 5."
		puts "My guess was #{computer_guess.upcase}"
		computer_guess_method(narrow_list, play_list, computer_word, computer_guess_list, computer_guess)
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
	# puts "#{array.length} words now."
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
			if compare(user_word, key) != value.to_i
				puts "You told me that your word had #{value} letters in common with #{key.upcase}."  
				puts "Actually, it has #{compare(user_word, key)} letters in common." 
			end
		end
	end

	puts "My word was #{computer_word.upcase}."

	rematch
end

gameplay
