require_relative 'turn'

class UserTurn < Turn

	def run
		@guess_valid = true
		puts "=======YOUR TURN======="
		get_response
		help_if_asked
		check_validity
		check_if_correct
		give_response
		puts "========================"
	end

	def get_response
		puts "Guess a five letter word."
		@guess = Word.new(gets.chomp.downcase)
		puts "Your guess was #{@guess.upcase}"
	end

	def help_if_asked
		if give_up?
	    puts "That is super lame.  For real."
	    puts "My word was #{@computer_word.upcase}."
	    Rematch.new.run
	  elsif @guess == "view"
			@guess_list_hash.each {|word, letters| puts "#{word.upcase}: #{letters}"}
			run
	  end
	end

	def check_if_correct
		if @guess == @computer_word
			puts "You won!  Congratulations"
	    Rematch.new.run
	  end
	end

	def give_up?
		@guess == "give up"
	end

	def check_validity
	  previously_guessed_error if already_guessed?
	  wrong_num_letters_error unless five_letters?
	  repeat_letters_error if @guess.repeat_letters?
	  not_in_dictionary_error unless in_dictionary?

		run unless @guess_valid
	end

	def invalid
		@guess_valid = false
	end

	def in_dictionary?
		@play_list.include?(@guess)
	end

	def not_in_dictionary_error
		puts "Sorry!  That is not a word!"
		@guess_valid = false
	end

	def already_guessed?
		!!@guess_list_hash.has_key?(@guess)
	end

	def five_letters?
		@guess.length == 5
	end

	def repeat_letters_error
		puts "Make sure your guess has no repeat letters."
		invalid
	end

	def wrong_num_letters_error
		puts "Your word did not have 5 letters."
		puts "Make sure your word has exactly 5 letters!"
		invalid
	end

	def previously_guessed_error
		puts "You already guessed that word."
		puts "#{@guess.upcase}: #{@guess_list_hash[@guess]}"
		invalid
	end

	def give_response
		value = @computer_word.compare(@guess)
		puts "#{@guess.upcase}: #{value}"
		@guess_list_hash[@guess]=value
	end

end
