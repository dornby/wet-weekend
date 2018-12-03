class Search < ApplicationRecord

  def show_forecasts
      Forecast.new.extract_forecasts
  end

end
