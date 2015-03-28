class Movie < ActiveRecord::Base
	def self.get_all_ratings
		#byebug
		Movie.select("DISTINCT rating").map(&:rating)
	end
end
