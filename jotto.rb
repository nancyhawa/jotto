require_relative 'wordlist'
require_relative 'comp_choice_list'
require_relative 'directions'

class JottoGame
	
	def initialize
		@play_list = (WordList.new(dictionary)).word_sort
		@computer_list = (WordList.new(compwordlist)).word_sort
		puts "Playlist item 27 is #{@play_list[26]}"
		@guess_list_hash = Hash.new
		@computer_word = Word.new(@computer_list.random_word)
		@directions = directions?
		@playernum = playernum?
	end

	def turn
	puts "Guess a five letter word."
	guess = Word.new(gets.chomp)
	puts "Your guess was #{guess}"

	  if guess.downcase == @computer_word.downcase
		puts "You won!  Congratulations"
	    rematch
	  elsif @guess_list_hash.has_key?(guess)
	  	puts "You already guessed that word."
	  	puts "#{guess.upcase}: #{guess_list[guess]}"
	  	turn
	  elsif guess.downcase == "give up"
	    puts "That is super lame.  For real."
	    puts "My word was #{@computer_word.upcase}."
	    rematch
	  elsif guess.downcase == "view"
		guess_list.each do |key, value|
			puts "#{key.upcase}: #{value}"
		end
		turn
	  elsif guess.length != 5
	    puts "Make sure your word has 5 letters!"
	    turn
	  elsif guess.repeat_letters? == true
	    puts "Make sure your guess has no repeat letters."
	    turn
	  elsif @play_list.include?(guess) == false
		puts "Sorry!  That is not a word!"
		turn
	  else
		value = @computer_word.compare(guess)
		puts "#{guess.upcase}: #{value}"
		add_to_hash(guess, value, @guess_list_hash)
		turn
	  end
	end

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

		puts "I will choose a five letter word, and you must guess it."
		puts "Every time you guess, I will tell you how many letters your word has 
		in common with mine."

	  turn

	end

	def add_to_hash(guess, value, hash)
		hash[guess] = value
	end

	def rematch
	  puts "Great game!"
	  puts "Would you like a rematch? Answer 'Yes' or 'No'."
	  play_again = gets.chomp.downcase
	  if play_again == "yes"
	    JottoGame.new
	  elsif play_again == "no"
	    puts "Have a great day!  I hope you had fun!"
	    abort("END OF GAME")
	  else 
	    puts "I don't understand that response."
	    rematch
	  end
	end

end

class WordList < Array
	attr_accessor :array

	def initialize(array)
		super
		@array = array
	end

	def word_sort
		list = []

		@array.each do |x|
			x = Word.new(x)
			if x.length == 5 && x.repeat_letters? == false
				list.push(x)
			end
		end
		WordList.new(list)
	end

	def random_word
		@array[rand(@array.length - 1)]
	end

	# def refine_list(array, guess, letters_in_common, play_list, computer_word, computer_guess_list)	
	# 	array = array - [guess]
	# 	array.each do | word |
	# 		if word.compare(guess) != letters_in_common
	# 		 	array = array - [word]
	# 		end
	# 	end
	# 	# puts "#{array.length} words now."
	# 	if array.length == 0
	# 		no_words_error(play_list, computer_word, computer_guess_list)
	# 	else
	# 		return array
	# 	end
	# end

end

class Word < String

	attr_accessor :word

	def initialize(word)
		super
		@word = word
	end

	def repeat_letters?
		x = 0
		while x < @word.split(//).length - 1
			return true if @word.split(//).count(@word.split(//)[x]) > 1
			x += 1
		end
		return false
	end

	def compare(other_word)
		count = 0
		@word.downcase.split("").each do |letter|
			count += 1 if other_word.downcase.split("").include?(letter)
		end
		return count
	end

end

# def computer_turn(narrow_list, play_list, computer_word, computer_guess_list)
# 	computer_guess = Word.new(random_word,narrow_list)

# 	puts "My turn."
# 	puts "My guess is #{computer_guess.upcase}."

# 	computer_guess_method(narrow_list, play_list, computer_word, computer_guess_list, computer_guess)
# end

# #I separated out this method to deal with an error I was getting when a player guessed
# #a word out of turn.	
# def computer_guess_method(narrow_list, play_list, computer_word, computer_guess_list, computer_guess)

# 	response = gets.chomp

# 	#I need to throw an error for a single letter response.
# 	#When the player types a word instead of a response, it thows the correct error, and then 
# 	#it asks the player again, but then the next guess is the player's last response.
# 	#I don't know why the response becomes the list to choose from.
# 	if [0, 1, 2, 3, 4, 5].include?(response.to_i) != true or response.length > 1
# 		puts "That is not a valid response.  Your response must be an integer 
# 		between 0 and 5."
# 		puts "My guess was #{computer_guess.upcase}"
# 		computer_guess_method(narrow_list, play_list, computer_word, computer_guess_list, computer_guess)
# 	elsif response.to_i == 5
# 		puts "Was that the word?  Answer Y or N."
# 		answer = gets.chomp.downcase
# 		if answer == "y"
# 			puts "I win!  I told you I would."
# 			puts "My word was #{computer_word.upcase}"
# 			rematch
# 		else 
# 			puts "Ok.  I'm close though.  Not many options."
# 			add_to_hash(computer_guess, response, computer_guess_list)
# 			refine_list(narrow_list, computer_guess, response.to_i, play_list, computer_word, computer_guess_list)
# 		end
# 	else
# 		add_to_hash(computer_guess, response, computer_guess_list)
# 		refine_list(narrow_list, computer_guess, response.to_i, play_list, computer_word, computer_guess_list)
# 	end
# end

# def no_words_error(play_list, computer_word, computer_guess_list)
# 	puts "One of us must have made a mistake."
# 	puts "I don't think there are any words that match the parameters you've given me."
# 	puts "What is your word?"
# 	user_word = gets.chomp.downcase

# 	if user_word.length != 5
#     	puts "Your word didn't have five letters!  That's why I got confused."
#   	elsif user_word.repeat_letters? == true
#     	puts "Whoops!  Your word had a letter that repeated.  That why I got confused!"
# 	elsif play_list.include?(user_word) == false
# 		puts "Sorry!  That word isn't in my dictionary.  That's why I got confused!"
# 	else
# 		puts "You made some errors."		
# 		computer_guess_list.each do |key, value|
# 			if user_word.compare(key) != value.to_i
# 				puts "You told me that your word had #{value} letters in common with #{key.upcase}."  
# 				puts "Actually, it has #{user_word.compare(key)} letters in common." 
# 			end
# 		end
# 	end

# 	puts "My word was #{computer_word.upcase}."

# 	rematch
# end

# def two_player
# 		#guess_list is a hash that stores the player's guesses and the #of letters they have 
# 		#in common with the computer's word
# 		guess_list = Hash.new

# 		#computer_guess_list is a hash that stores the computer's guesses and the #of letters 
# 		#they have in common with the player's word
# 		computer_guess_list = Hash.new

# 		computer_word = random_word((WordList.new).word_sort)

# 		#play_list is a list of all valid words for use in the game.
# 		play_list = word_sort(word_list)

# 		#narrow_list starts as a list of all valid words for use in the game, but as the 
# 		#computer gets more information, it deletes words from the list, "narrowing" it down
# 		#to the users word.
# 		narrow_list = WordList.new(@play_list)
	  	
# 		puts "You think you can beat me?  Highly unlikely."
# 		puts "I'll give you a head start. You go first!"
	 
# 		#Again, I don't think this code is "readable" but it works. 
# 		until false
# 			turn(computer_word, guess_list, play_list)
# 			narrow_list = computer_turn(narrow_list, play_list, 
# 				computer_word, computer_guess_list)
# 		end
# end

JottoGame.new

