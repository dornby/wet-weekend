require 'net/http'
require 'json'
require 'active_support'

class Cities

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

  def pick_random_city
    @random_city = CITIES.sample
  end

  def rainy_city
    pick_random_city
    response = JSON.parse(Net::HTTP.get("api.openweathermap.org", "/data/2.5/forecast?zip=#{@random_city["postal_code"]},fr&APPID=3a0eecab5afb71e7b03a1681177656ef"))
    forecasts = []
    allowed_hours = [7, 16]
    halfdays = {7 => "morning", 16 => "afternoon"}
    response["list"].each do |wad|
      if Time.at(wad["dt"]).wday.between?(5,7) && allowed_hours.include?(Time.at(wad["dt"]).hour)
        forecasts += [{
          "city_name" => @random_city["name"],
          "day" => "#{Time.at(wad["dt"]).wday}",
          "halfday" => "#{halfdays[Time.at(wad["dt"]).hour]}",
          "weather_main" => wad["weather"][0]["main"],
          "weather_description" => wad["weather"][0]["description"]
        }]
      end
    end
    forecasts
  end

end

p Cities.new.rainy_city
