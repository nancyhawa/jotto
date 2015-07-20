def directions?
	puts "Would you like me to review the rules of the game?"
	puts "Type 'Y' if yes and 'N' if you are ready to play without any instructions."

	example = Hash.new

	example["LIGHT"] = 2
	example["RIGHT"] = 3

	answer = gets.chomp.downcase
	if answer == "y"
		puts "The goal of this game is for you to guess the five letter word of my choosing"
		puts "My word will be exactly five letters long, and it will have no repeat letters."
		puts "For example, 'FUNNY' would not be a valid word because it contains two N's."
		puts "'TOTES would also be invalid because there are two T's, even though the T's are not consecutive."
		puts "In order to figure out my word, you will guess a five letter word."
		puts "I will tell you how many letters it has in common with mine."
		puts "The order of the letters does not matter."
		puts "Let me give you an example."
		puts "Let's say your first guess was 'LIGHT' and I told you it had two letters."
		puts "Then you guess 'RIGHT' and I tell you it has three letters."
		puts "You can be certain that there is an R somewhere in the word, because the count went up when you added only an R."
		puts "However, you cannot know whether the R is the first letter."
		puts "You can also be certain that there is no 'L' in the word."
		puts "Whenever it is your turn to guess a word, you can type the word 'view' instead, and you will get a list of all the words you have guessed."
		puts "This is how it will look."

		example.each do |key, value|
			puts "#{key.upcase}: #{value}"
		end

		puts "You can also play against me.  You will come up with a word as well, and I will try to figure it out."
		puts "We will take turns guessing, telling eachother how many letters those guesses have in common with our words."
		puts "Whoever figures out the other players word first wins."
		puts "Realistically, you are going to lose.  But you can try."
	end
end