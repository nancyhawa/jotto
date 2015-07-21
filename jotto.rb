require_relative 'wordlist'
require_relative 'comp_choice_list'
require_relative 'directions'
require_relative 'wordclass'
require_relative 'rematch'
require_relative 'userturn'
require_relative 'wordlistclass'
require_relative 'computer_turn'

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

	  (UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	end

	def add_to_hash(guess, value, hash)
		hash[guess] = value
	end

	def two_player	  	
		puts "You think you can beat me?  Highly unlikely."
		puts "I'll give you a head start. You go first!"

		(UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	end
	
	

end




JottoGame.new

