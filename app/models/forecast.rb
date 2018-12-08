require 'net/http'
require 'json'

class Forecast #< ApplicationRecord

  CITIES = [
    {"postal_code" => "93170",
      "name" => "Bagnolet"
    },
    {"postal_code" => "75001",
      "name" => "Paris"
    },
    {"postal_code" => "34000",
      "name" => "Montpellier"
    },
    {"postal_code" => "33000",
      "name" => "Bordeaux"
    },
    {"postal_code" => "59000",
      "name" => "Lille"
    },
    {"postal_code" => "40000",
      "name" => "Nantes"
    },
    {"postal_code" => "29000",
      "name" => "Quimper"
    }
  ]

  def extract_forecasts

    allowed_hours = [6, 7, 8, 15, 16, 17]
    halfdays = {6 => "Morning", 7 => "Morning", 8 => "Morning", 15 => "Afternoon", 16 => "Afternoon", 17 => "Afternoon"}
    forecast = []

    CITIES.each do |city|

      response = JSON.parse(Net::HTTP.get("api.openweathermap.org", "/data/2.5/forecast?zip=#{city["postal_code"]},fr&APPID=3a0eecab5afb71e7b03a1681177656ef"))

      city_forecast = {
        "name" => city["name"],
        "code" => city["postal_code"],
        "weather" => []
        }

      response["list"].each do |weather|
        if [0, 1].include?(Time.at(weather["dt"]).wday) && allowed_hours.include?(Time.at(weather["dt"]).hour)
          city_forecast["weather"] += [{
            "day" => "#{Time.at(weather["dt"]).strftime('%A')}",
            "halfday" => "#{halfdays[Time.at(weather["dt"]).hour]}",
            "weather_main" => weather["weather"][0]["main"],
            "weather_description" => weather["weather"][0]["description"],
            "weather_id" => weather["weather"][0]["id"],
            "icon_name" => if [200,202].include?(weather["weather"][0]["id"])
              "wi-day-thunderstorm"
            elsif weather["weather"][0]["id"].between?(500,504)
              "wi-day-rain"
            elsif weather["weather"][0]["id"].between?(512,599) || weather["weather"][0]["id"].between?(300,399)
              "wi-rain"
            elsif weather["weather"][0]["id"] == 511
              "wi-snow"
            end,
            "icon_code" => if [200,202].include?(weather["weather"][0]["id"])
              "f010"
            elsif weather["weather"][0]["id"].between?(500,504)
              "f008"
            elsif weather["weather"][0]["id"].between?(512,599) || weather["weather"][0]["id"].between?(300,399)
              "f019"
            elsif weather["weather"][0]["id"] == 511
              "f01b"
            end
          }]
        end
      end

      city_forecast["rainy_hd"] = city_forecast["weather"].count{|hd| [200, 202].include?(hd["weather_id"]) || hd["weather_id"].between?(500,599) || hd["weather_id"].between?(300,399)}

      forecast += [city_forecast]

    end
    forecast
  end

  def select_rainy_forecasts
    max_rainy_hd = extract_forecasts.max_by {|c| c["rainy_hd"]}["rainy_hd"]
    rainy_forecasts = extract_forecasts.reject{|c| c["rainy_hd"] < max_rainy_hd}
    rainy_forecasts.sample
  end

  def somewhere_rainy?
    select_rainy_forecasts.count > 0
  end

end
