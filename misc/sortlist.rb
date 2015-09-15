require_relative '../app/models/wordlist'

def repeat_letters?(word)
	x = 0
	while x < word.split(//).length - 1
		return true if word.split(//).count(word.split(//)[x]) > 1
		x += 1
	end
	return false
end

def sort

list = []

dictionary.each do |x|
	if (x.length == 5) && repeat_letters?(x) == false
		list.push(x)
	end
end

print list

end

sort
