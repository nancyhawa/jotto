require_relative 'wordlist'
require_relative 'comp_choice_list'
require_relative 'directions'
require_relative 'wordclass'
require_relative 'rematch'
require_relative 'userturn'
require_relative 'wordlistclass'
require_relative 'computer_turn'
require_relative 'no_words_error'

class JottoGame
	def initialize
		@play_list = (WordList.new(dictionary)).word_sort
		@computer_list = (WordList.new(compwordlist)).word_sort
		@guess_list_hash = {}
		@computer_word = Word.new(@computer_list.random_word)
		@computer_guess_list = {}
		@narrow_list = WordList.new(@play_list)
	end

	def run
		directions?
		playernum?
	end

	def playernum?
		puts "Would you like to play on your own or compete against me?"
		puts "Enter '1' for a one player game or '2' to play agaist me."

		@playernum = gets.chomp.to_i
		one_player if @playernum == 1
		two_player if @playernum == 2

		puts "I didn't understand your response.  Would you like to play against the computer or on your own."
		puts "Enter '1' for a one player game or '2' for a 2 player game."
		playernum?
	end

	def one_player
		puts "I will choose a five letter word, and you must guess it."
		puts "Every time you guess, I will tell you how many letters your word has
		in common with mine."

		loop do
			user_turn
		end
	end

	def two_player
		puts "You think you can beat me?  Highly unlikely."
		puts "I'll give you a head start. You go first!"

		loop do
			user_turn
			computer_turn
		end
	end

	def user_turn
		(UserTurn.new(@narrow_list, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	end

	def computer_turn
		ComputerTurn.new(@narrow_list, @computer_word, @guess_list_hash, @play_list, @computer_guess_list).run

	end

end

JottoGame.new.run
