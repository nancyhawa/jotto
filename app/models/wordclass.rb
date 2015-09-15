class Word < String

	def initialize(word)
		super
		@word = word
	end

	def repeat_letters?
		word = @word.downcase.split(//)
		word.map! { |l| word.count(l) }.sort.last > 1
	end

	def compare(other_word)
		word = Word.new(@word)
		word2 = Word.new(other_word)

		word.letters.count { |letter| word2.letters.include?(letter) }
	end

	def letters
		downcase.split("")
	end


end
#
#
# class Word < String
#
# 	attr_accessor :word
#
# 	def initialize(word)
# 		super
# 		@word = word
# 	end
#
# 	# def repeat_letters?
# 	# 	x = 0
# 	# 	while x < @word.split(//).length - 1
# 	# 		return true if @word.split(//).count(@word.split(//)[x]) > 1
# 	# 		x += 1
# 	# 	end
# 	# 	return false
# 	# end
#
#
# 	def repeat_letters?
# 		word = @word.downcase.split(//)
# 		word.map! { |l| word.count(l) }.sort.last > 1
# 	end
#
# 	# def compare(other_word)
# 	# 	count = 0
# 	# 	@word.downcase.split("").each do |letter|
# 	# 		count += 1 if other_word.downcase.split("").include?(letter)
# 	# 	end
# 	# 	return count
# 	# end
#
# 	def compare(other_word)
# 		word1 = @word.downcase.split("")
# 		word2 = other_word.downcase.split("")
#
# 		word1.count { |letter| word2.include?(letter) }
# 	end
# end
