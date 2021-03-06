require_relative 'no_words_error'
require_relative 'userturn'
require_relative 'turn'

class ComputerTurn < Turn

	def run
		computer_guesses
	end

	def computer_guesses
		@computer_guess = Word.new(@narrow_list.random_word)

		puts "My turn."
		puts "My guess is #{@computer_guess.upcase}."
		computer_processes_response
	end

	def computer_processes_response
		get_user_response
		check_user_response_validity
		check_response_five
		process_response
		no_words_error
	end

	def no_words_error
		NoWordsError.new(@narrow_list, @play_list, @computer_guess_list, @computer_word).run
	end

	def get_user_response
		@response = Word.new(gets.chomp)
	end

	def check_user_response_validity
		unless ["0", "1", "2", "3", "4", "5"].include?(@response)
			puts "That is not a valid response.  Your response must be an integer between 0 and 5."
			puts "My guess was #{@computer_guess.upcase}"
			computer_processes_response
		end
	end

	def check_response_five
		if @response.to_i == 5
			puts "Was that the word?  Answer Y or N."
			answer = gets.chomp.downcase
			if answer == "y"
				puts "I win!  I told you I would."
				puts "My word was #{@computer_word.upcase}"
				Rematch.new.run
			else
				puts "Ok.  I'm close though.  Not many options."
			end
		end
	end

	def process_response
		@computer_guess_list[@computer_guess] = @response
		@narrow_list = @narrow_list.refine(@computer_guess, @response.to_i)
	end

end
