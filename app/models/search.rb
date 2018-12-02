class Search < ApplicationRecord

  def pick_random_destination
    city = Cities.new.pick_random_city
    p city["name"]
  end

end
