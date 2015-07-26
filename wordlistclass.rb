class WordList < Array

	def initialize(array)
		super
		@array = array
	end

	def word_sort
		list = []

		@array.each do |x|
			x = Word.new(x)
			list.push(x) unless x.repeat_letters? || x.length != 5
		end
		WordList.new(list)
	end

	def random_word
		@array[rand(@array.length - 1)]
	end

	def refine(guess, letters_in_common)	
		@array = @array - [guess]
		@array.each do | word |
			@array = @array - [word] unless word.compare(guess) == letters_in_common
		end
		
		return WordList.new(@array)	
	end
end