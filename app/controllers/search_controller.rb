class SearchController < ApplicationController

  def create
    @search = Search.new
    @search.save
  end

  def show
    create
    p @search.show_forecast
  end

end
