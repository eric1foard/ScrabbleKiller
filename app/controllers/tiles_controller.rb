class TilesController < ApplicationController

	def index
	end

	def play
		user_tiles = params[:user_tiles]
		filepath = "#{Rails.root}/public/wwf.txt"
		dict = init_set(filepath);
		puts "completed dict init"
		max_play = search_for_max(user_tiles, dict)
		render :text=> max_play
	end

	# string -> string
	# INPUT: string representing tiles in user's hand
	# OUTPUT: valid scrabble word of maximum value, 
	# or error if none exists
	def search_for_max(user_tiles, dict)
		possible_plays = Containers::PriorityQueue.new
		#convert tiles to array
		user_tiles = user_tiles.chars.to_a
		i = user_tiles.length

		while (i>0) do
			perms = user_tiles.permutation(i)
			for perm in perms do
				score = get_score(perm)
				#reformat array to string
				perm = perm.join("")
				possible_plays.push(perm, score)
			end
			
			# is there a valid word of length i?
			while (not possible_plays.empty?) do
				word = possible_plays.pop
				if is_valid_word(word, dict)
					return word
				end	
			end
			i = i-1
		end
		return "no word found!"
	end

	def init_set(filepath)
		dict = Set.new
		IO.foreach(filepath) do |valid_word|
			dict.add(valid_word.downcase.chomp)
		end
		return dict
	end

	def is_valid_word(word, dict)
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
		when "e" 
			return 1
		when "i" 
			return 1
		when "l" 
			return 1
		when "n" 
			return 1
		when "o" 
			return 1
		when "r" 
			return 1
		when "s" 
			return 1
		when "t" 
			return 1
		when "u" 
			return 1
		when "g" 
			return 2
		when "d" 
			return 2
		when "p" 
			return 3
		when "c" 
			return 3
		when "m" 
			return 3
		when "b" 
			return 3
		when "f" 
			return 4
		when "h" 
			return 4
		when "v" 
			return 4
		when "w" 
			return 4
		when "y" 
			return 4
		when "k" 
			return 5
		when "x" 
			return 8
		when "j" 
			return 8
		when "z" 
			return 10
		when "q" 
			return 10
		else 
			return 0
		end
	end
end
