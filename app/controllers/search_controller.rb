class SearchController < ApplicationController

  def create
    @search = Search.new
    @search.save
  end

  def show_forecast
      ForecastsController.new.select_rainy_forecasts
  end

  def got_forecast
      ForecastsController.new.got_forecasts?
  end

  def somewhere_rainy
      ForecastsController.new.somewhere_rainy?
  end

end
