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
		if @array.length == 0
			no_words_error
		else
			return WordList.new(@array)
		end
	end

end