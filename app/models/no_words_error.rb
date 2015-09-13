class NoWordsError

	def initialize(narrow_list, play_list, computer_guess_list, computer_word)
		@narrow_list = narrow_list
		@play_list = play_list
		@computer_guess_list = computer_guess_list
		@computer_word = computer_word
	end

	def run
		if @narrow_list.length == 0
			get_user_word
			check_letter_count
			check_repeat_letters
			check_dictionary
			check_response_errors
			end_game
		end
	end

	def get_user_word
		puts "One of us must have made a mistake."
		puts "I don't think there are any words that match the parameters you've given me."
		puts "What is your word?"
		@user_word = Word.new(gets.chomp.downcase)
	end

	def check_letter_count
		unless @user_word.length == 5
	    puts "Your word didn't have five letters!  That's why I got confused."
	  end
	end

	def check_repeat_letters
	   	puts "Whoops!  Your word had a letter that repeated.  That why I got confused!" if @user_word.repeat_letters?
	end

	def check_dictionary
		unless @play_list.include?(@user_word)
			puts "Sorry!  That word isn't in my dictionary.  That's why I got confused!"
		end
	end

	def check_response_errors
		puts "You made some errors."
		@computer_guess_list.each do |key, value|
			unless @user_word.compare(Word.new(key)) == value.to_i
				puts "You told me that your word had #{value} letters in common with #{key.upcase}."
				puts "Actually, it has #{@user_word.compare(key)} letters in common."
			end
		end
	end

	def end_game
		puts "My word was #{@computer_word.upcase}."
		Rematch.new.run
	end
end
