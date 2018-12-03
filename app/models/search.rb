class Search < ApplicationRecord

  def show_forecasts
      Forecast.new.select_rainy_forecasts
  end

end
