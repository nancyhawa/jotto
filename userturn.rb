class UserTurn

	def initialize(narrow_list, playernum, computer_word, guess_list_hash, play_list, computer_guess_list)
		@narrow_list = narrow_list
		@playernum = playernum
		@computer_word = computer_word
		@guess_list_hash = guess_list_hash
		@play_list = play_list
		@computer_guess_list = computer_guess_list
	end

	def run
		get_response
		help_if_asked
		check_validity
		check_if_correct
		give_response
		next_turn
	end

	def get_response
		puts "Guess a five letter word."
		@guess = Word.new(gets.chomp.downcase)
		puts "Your guess was #{@guess}"
	end

	def help_if_asked
		if give_up?
	    puts "That is super lame.  For real."
	    puts "My word was #{@computer_word.upcase}."
	    Rematch.new.run
	  elsif @guess == "view"
			@guess_list_hash.each do |key, value|
				puts "#{key.upcase}: #{value}"
	  	end
			(UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	  end
	end

	def check_if_correct
		if @guess == @computer_word.downcase
			puts "You won!  Congratulations"
	    Rematch.new.run
	  end
	end

	def give_up?
		@guess == "give up"
	end

	def check_validity
	  if @guess_list_hash.has_key?(@guess)
	  	puts "You already guessed that word."
	  	puts "#{@guess.upcase}: #{@guess_list_hash[@guess]}"
	  	(UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	  elsif @guess.length != 5
	    puts "Make sure your word has 5 letters!"
	    (UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	  elsif @guess.repeat_letters? == true
	    puts "Make sure your guess has no repeat letters."
	    (UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
	  elsif @play_list.include?(@guess) == false
			puts "Sorry!  That is not a word!"
			(UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
		end
	end

	def give_response
		value = @computer_word.compare(@guess)
		puts "#{@guess.upcase}: #{value}"
		@guess_list_hash[@guess]=value
	end

	def next_turn
		if @playernum == 1
			(UserTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list)).run
		elsif @playernum == 2
			ComputerTurn.new(@narrow_list, @playernum, @computer_word, @guess_list_hash, @play_list, @computer_guess_list).run
		end
	end

end