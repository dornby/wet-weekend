class SearchController < ApplicationController

  def create
    @search = Search.new
    @search.save
  end

  def show_forecast
      ForecastsController.new.select_rainy_forecasts
  end

end
