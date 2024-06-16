class Movie < ActiveRecord::Base
  def self.all_ratings
    # Return all possible movie ratings
    %w(G PG PG-13 R)
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      # If no ratings list is provided, return all movies
      Movie.all
    else
      # Return movies with ratings in the provided list
      Movie.where(rating: ratings_list)
    end
  end
end
