class TilesController < ApplicationController

	def index
	end

	def play
		user_tiles = params[:user_tiles].downcase.chomp
		filepath = "#{Rails.root}/public/wwf.txt"
		time1 = Time.new
		trie = init_trie(filepath, user_tiles)	
		time2 = Time.new	
		puts "completed trie init"
		max_play = search_for_max(user_tiles, trie)
		
		puts "TIME TO INIT TRIE:" + (time2-time1).to_s
		render :text=> max_play
	end

	# string -> string
	# INPUT: string representing tiles in user's hand
	# OUTPUT: valid scrabble word of maximum value, 
	# or error if none exists
	def search_for_max(user_tiles, trie)
		num_tiles = user_tiles.length
		max_score = 0
		max_play = ""
		possible_plays = user_tiles.chars.to_a.permutation(num_tiles)

		possible_plays.each do |perm|
			#convert back to string for trie search
			perm = perm.join("")
			#longest prefix returns key
			prefix = trie.longest_prefix(perm)
			#found optimal play
			if prefix.length == num_tiles
				return prefix
			end

			if prefix != ""
				play_score = trie.get(prefix)

				if play_score > max_score
					max_score = play_score
					max_play = prefix
				end
			end
		end

		if max_score > 0
			return "you cheater! play '" + max_play + "' for " + max_score.to_s + " points and you're sure to win!"
		end
		return "sorry friend you're out of luck!"
	end

	# filepath, string -> trie
	# reads from file and builds trie of valid words. Filters
	# out all words from dict that are not candidates for max word 
	def init_trie(filepath, user_tiles)
		trie = Containers::Trie.new
		tile_vals = init_tiles_hash
		user_tiles = user_tiles.chars.to_a

		IO.foreach(filepath) do |valid_word|
			word = valid_word.downcase.chomp.chars.to_a
			# if word is a subset user_tiles, it
			# can be formed with user_tiles so push it
			if (word-user_tiles).empty?
				trie.push(word.join(""), get_score(word, tile_vals))
			end
		end
		return trie
	end

	def is_valid_word(word, trie)
		if trie.has_key? word.downcase.chomp
			return true
		end
		return false
	end

	#array,hash -> integer
	# INPUT: a possible word, valid or invalid as array
	# OUTPUT: integer representing score for word
	def get_score(word, tile_vals)
		score = 0
		word.each do |w|
			score+=letter_value(w, tile_vals)
		end
		return score
	end

	# char -> integer
	# INPUT: a letter [a, z]
	# OUTPUT: the score for the letter as assigned in scrabble
	def letter_value(letter, tile_vals)
		return tile_vals[letter]
	end

	def init_tiles_hash
		tile_vals = Hash.new

		tile_vals["a"] = 1
		tile_vals["e"] = 1
		tile_vals["i"] = 1
		tile_vals["l"] = 1
		tile_vals["n"] = 1
		tile_vals["o"] = 1
		tile_vals["r"] = 1
		tile_vals["s"] = 1
		tile_vals["t"] = 1
		tile_vals["u"] = 1
		tile_vals["g"] = 2
		tile_vals["d"] = 2
		tile_vals["p"] = 3
		tile_vals["c"] = 3
		tile_vals["m"] = 3
		tile_vals["b"] = 3
		tile_vals["f"] = 4
		tile_vals["h"] = 4
		tile_vals["v"] = 4
		tile_vals["w"] = 4
		tile_vals["y"] = 4
		tile_vals["k"] = 5
		tile_vals["x"] = 8
		tile_vals["j"] = 8
		tile_vals["z"] = 10
		tile_vals["q"] = 10
		return tile_vals
	end
end
