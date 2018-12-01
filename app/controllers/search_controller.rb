class SearchController < ApplicationController

  def index
  end

  def create
    @search = Search.new
    @search.save
  end

end
