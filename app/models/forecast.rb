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
        "city_name" => city["name"],
        "city_code" => city["postal_code"],
        "weather" => []
        }

      response["list"].each do |weather|
        if Time.at(weather["dt"]).wday.between?(5,7) && allowed_hours.include?(Time.at(weather["dt"]).hour)
          city_forecast["weather"] += [{
            "day" => "#{Time.at(weather["dt"]).strftime('%A')}",
            "halfday" => "#{halfdays[Time.at(weather["dt"]).hour]}",
            "weather_main" => weather["weather"][0]["main"],
            "weather_description" => weather["weather"][0]["description"]
          }]
        end
      end

      forecast += [city_forecast]

    end

    forecast

  end

  def count_rainy
    forecast = extract_forecasts
    city_forecasts = []
    forecast.each do |city_forecast|
      city_forecasts += [
        {"city_name" => "#{city_forecast["city_name"]}",
        "city_code" => "#{city_forecast["city_code"]}",
        "city_rainy_hd" => city_forecast["weather"].count{|hd| hd["weather_main"] == "Rain"}
        }
      ]
    end
    p city_forecasts
  end

end

Forecast.new.count_rainy
