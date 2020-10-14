class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list != nil
      where(rating: ratings_list)
    end
  end
  
  def self.all_ratings
    distinct.pluck(:rating)
  end
end