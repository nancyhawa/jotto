require_relative 'wordlist'
require_relative 'comp_choice_list'
require_relative 'directions'
#require_relative 'wordlistclass'
require_relative 'wordclass'

class JottoGame 
	
	def initialize
		@play_list = (WordList.new(dictionary)).word_sort
		@computer_list = (WordList.new(compwordlist)).word_sort
		@guess_list_hash = Hash.new
		@computer_word = Word.new(@computer_list.random_word)
		@computer_guess_list = Hash.new
		@narrow_list = WordList.new(@play_list)
		@directions = directions?
		@playernum = playernum?
	end

	def turn
	puts "Guess a five letter word."
	guess = Word.new(gets.chomp.downcase)
	puts "Your guess was #{guess}"

	  if guess.downcase == @computer_word.downcase
		puts "You won!  Congratulations"
	    rematch
	  elsif @guess_list_hash.has_key?(guess)
	  	puts "You already guessed that word."
	  	puts "#{guess.upcase}: #{@guess_list_hash[guess]}"
	  	turn
	  elsif guess.downcase == "give up"
	    puts "That is super lame.  For real."
	    puts "My word was #{@computer_word.upcase}."
	    rematch
	  elsif guess.downcase == "view"
		@guess_list_hash.each do |key, value|
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
	  end

	if @playernum == 1
		turn
	elsif @playernum == 2
		computer_turn
	end
	end

	def playernum?
		puts "Would you like to play on your own or compete against me?"
		puts "Enter '1' for a one player game or '2' to play agaist me."
		
		players = gets.chomp
		if players == "1"
			@playernum = 1
			one_player
		elsif players == "2"
			@playernum = 2
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

###The methods below are all for the two player version only.

	def two_player	  	
		puts "You think you can beat me?  Highly unlikely."
		puts "I'll give you a head start. You go first!"

		turn
	end

	def computer_turn
		computer_guess = Word.new(@narrow_list.random_word)

		puts "My turn."
		puts "My guess is #{computer_guess.upcase}."

		computer_guess_method(computer_guess)
		turn
	end

	#I separated out this method to deal with an error I was getting when a player guessed
	#a word out of turn.	
	def computer_guess_method(computer_guess)

		response = gets.chomp

		#I need to throw an error for a single letter response.
		#When the player types a word instead of a response, it thows the correct error, and then 
		#it asks the player again, but then the next guess is the player's last response.
		#I don't know why the response becomes the list to choose from.
		if [0, 1, 2, 3, 4, 5].include?(response.to_i) != true or response.length > 1
			puts "That is not a valid response.  Your response must be an integer 
			between 0 and 5."
			puts "My guess was #{computer_guess.upcase}"
			computer_guess_method(computer_guess)
		elsif response.to_i == 5
			puts "Was that the word?  Answer Y or N."
			answer = gets.chomp.downcase
			if answer == "y"
				puts "I win!  I told you I would."
				puts "My word was #{@computer_word.upcase}"
				rematch
			else 
				puts "Ok.  I'm close though.  Not many options."
				add_to_hash(computer_guess, response, @computer_guess_list)
				@narrowlist = @narrow_list.refine(computer_guess, response.to_i)
			end
		else
			add_to_hash(computer_guess, response, @computer_guess_list)
			@narrowlist = @narrow_list.refine(computer_guess, response.to_i)
			if @narrowlist.length == 0
				no_words_error
			end
		end
	end


	def no_words_error
		puts "One of us must have made a mistake."
		puts "I don't think there are any words that match the parameters you've given me."
		puts "What is your word?"
		user_word = Word.new(gets.chomp.downcase)

		if user_word.length != 5
	    	puts "Your word didn't have five letters!  That's why I got confused."
	  	elsif user_word.repeat_letters? == true
	    	puts "Whoops!  Your word had a letter that repeated.  That why I got confused!"
		elsif @play_list.include?(user_word) == false
			puts "Sorry!  That word isn't in my dictionary.  That's why I got confused!"
		else
			puts "You made some errors."		
			@computer_guess_list.each do |key, value|
				if user_word.compare(Word.new(key)) != value.to_i
					puts "You told me that your word had #{value} letters in common with #{key.upcase}."  
					puts "Actually, it has #{user_word.compare(key)} letters in common." 
				end
			end
		end

		puts "My word was #{@computer_word.upcase}."

		rematch
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

	def refine(guess, letters_in_common)	
		@array = @array - [guess]
		@array.each do | word |
			if word.compare(guess) != letters_in_common
			 	@array = @array - [word]
			end
		end
		
		return WordList.new(@array)
	
	end

end


JottoGame.new

