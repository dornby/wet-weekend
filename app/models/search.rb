class Search < ApplicationRecord

  def show_forecast
      Forecast.new.select_rainy_forecasts
  end

end
