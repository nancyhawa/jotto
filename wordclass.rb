class Word < String

	attr_accessor :word

	def initialize(word)
		super
		@word = word
	end

	def repeat_letters?
		x = 0
		while x < @word.split(//).length - 1
			return true if @word.split(//).count(@word.split(//)[x]) > 1
			x += 1
		end
		return false
	end

	def compare(other_word)
		count = 0
		@word.downcase.split("").each do |letter|
			count += 1 if other_word.downcase.split("").include?(letter)
		end
		return count
	end

end