class SearchController < ApplicationController

  def create
    @search = Search.new
    @search.save
  end

  def show
    create
    p @search.pick_random_destination
  end

end
