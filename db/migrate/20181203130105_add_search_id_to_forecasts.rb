class AddSearchIdToForecasts < ActiveRecord::Migration[5.2]
  def change
    add_column :forecasts, :search_id, :int
  end
end
