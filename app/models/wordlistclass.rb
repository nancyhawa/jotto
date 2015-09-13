require_relative 'wordclass'

class WordList < Array

	def initialize(array)
		super
		@array = array.map { |string| Word.new(string)}
	end

	def word_sort
		@array = @array.select { |word| word.length == 5}.reject
		@array = @array.reject { |word| Word.new(word).repeat_letters? }
		WordList.new(@array)
	end

	def random_word
		@array[rand(@array.length - 1)]
	end

	def refine(guess, letters_in_common)
		WordList.new(@array.select { | word | word.compare(guess) == letters_in_common })
	end
end

# class WordList < Array
#
# 	def initialize(array)
# 		super
# 		@array = array.map { |string| Word.new(string)}
# 	end
#
# 	def word_sort
# 		list = []
#
# 		@array.each do |x|
# 			x = Word.new(x)
# 			list.push(x) unless x.repeat_letters? || x.length != 5
# 		end
# 		WordList.new(list)
#
# 	end
#
# 	def random_word
# 		@array[rand(@array.length - 1)]
# 	end
#
# 	def refine(guess, letters_in_common)
# 		WordList.new(@array.select { | word | word.compare(guess) == letters_in_common })
# 	end
# end
