class TilesController < ApplicationController

	def index
	end

	def play
		user_tiles = params[:user_tiles]
		puts user_tiles
		filepath = "#{Rails.root}/public/sowpods.txt"
		dict = init_set(filepath);
		plays = possible_plays(user_tiles)
		max_play = search_for_max(plays, dict)
		render :text=> max_play
		
	end
	# string -> array
	# INPUT: string representing tiles in user's hand
	# OUTPUT: priority queue of all permutations of tiles in user's hand
	def possible_plays(user_tiles)
		possible_plays = Containers::PriorityQueue.new

		#convert tiles to string so we can use
		# permutation method
		user_tiles = user_tiles.chars.to_a

		for i in 1..user_tiles.length do 
			perms = user_tiles.permutation(i)
			for perm in perms do
				score = get_score(perm)
				#reformat array to string
				perm = perm.join("")
				possible_plays.push(perm, score)
			end
		end
		return possible_plays
	end

	#PQ -> string
	# INPUT: PQ returned by possible_plays
	# OUTPUT: valid scrabble word of maximum value
	def search_for_max(possible_plays, dict)
		found = false

		while ((not found) && (not possible_plays.empty?)) do
			word = possible_plays.pop
			# puts "PERM: " + word
			if is_valid_word(word, dict)
				found = true
			end	
		end
		return word
		# return word
	end

	def init_set(filepath)
		dict = Set.new
		IO.foreach(filepath) do |valid_word|
			dict.add(valid_word.downcase.chomp)
		end
		return dict
	end

	def is_valid_word(word, dict)
		# open sowpods.txt
		# clean word 
		if dict.member? word.downcase.chomp
			return true
		end
		return false
	end

	#array -> integer
	# INPUT: a possible word, valid or invalid as array
	# OUTPUT: integer representing score for word
	def get_score(word)
		score = 0
		word.each do |i|
			score+=letter_value(i)
		end
		return score
	end

	# char -> integer
	# INPUT: a letter [a, z]
	# OUTPUT: the score for the letter as assigned in scrabble
	def letter_value(letter)
		case letter
		when "a" 
			return 1
		when "b" 
			return 3
		when "c" 
			return 3
		when "d" 
			return 2
		when "e" 
			return 1
		when "f" 
			return 4
		when "g" 
			return 2
		when "h" 
			return 4
		when "i" 
			return 1
		when "j" 
			return 8
		when "k" 
			return 5
		when "l" 
			return 1
		when "m" 
			return 3
		when "n" 
			return 1
		when "o" 
			return 1
		when "p" 
			return 3
		when "q" 
			return 10
		when "r" 
			return 1
		when "s" 
			return 1
		when "t" 
			return 1
		when "u" 
			return 1
		when "v" 
			return 4
		when "w" 
			return 4
		when "x" 
			return 8
		when "y" 
			return 4
		when "z" 
			return 10
		else 
			return 0
		end
	end
end
