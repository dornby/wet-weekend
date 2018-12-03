require 'net/http'
require 'json'

class Forecast# < ApplicationRecord

  CITIES = [
    {"postal_code" => "93170",
      "name" => "Bagnolet"
    },
    {"postal_code" => "75001",
      "name" => "Paris"
    },
    {"postal_code" => "34000",
      "name" => "Montpellier"
    }
  ]

  def extract_forecasts

    allowed_hours = [7, 16]
    halfdays = {7 => "Morning", 16 => "Afternoon"}
    forecast = []

    CITIES.each do |city|

      response = JSON.parse(Net::HTTP.get("api.openweathermap.org", "/data/2.5/forecast?zip=#{city["postal_code"]},fr&APPID=3a0eecab5afb71e7b03a1681177656ef"))

      city_forecast = {
        "name" => city["name"],
        "code" => city["postal_code"],
        "weather" => []
        }

      response["list"].each do |weather|
        if Time.at(weather["dt"]).wday.between?(5,7) && allowed_hours.include?(Time.at(weather["dt"]).hour)
          city_forecast["weather"] += [{
            "day" => "#{Time.at(weather["dt"]).strftime('%A')}",
            "halfday" => "#{halfdays[Time.at(weather["dt"]).hour]}",
            "weather_main" => weather["weather"][0]["main"],
            "weather_description" => weather["weather"][0]["description"],
            "weather_id" => weather["weather"][0]["id"]
          }]
        end
      end

      city_forecast["rainy_hd"] = city_forecast["weather"].count{|hd| hd["weather_id"].between?(200,202) || hd["weather_id"] == 310 || hd["weather_id"] == 312 || hd["weather_id"] == 314 || hd["weather_id"].between?(500,599)}

      forecast += [city_forecast]

    end
    forecast
  end

  def select_rainy_forecasts
    max_rainy_hd = extract_forecasts.max_by {|c| c["rainy_hd"]}["rainy_hd"]
    rainy_forecasts = extract_forecasts.reject{|c| c["rainy_hd"] < max_rainy_hd}
    rainy_forecasts
  end

  def somewhere_rainy?
    select_rainy_forecast.count > 0
  end

end

p Forecast.new.somewhere_rainy?
