require 'httparty'

class WeatherApi
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def initialize(api_key)
    @options = { query: { appid: api_key, units: 'imperial' } } # 'imperial' for Fahrenheit. Use Metric for Celsius.
  end

  # Return weather for given address.
  def weather_by_address(address)
    self.class.get("/weather?q=#{address}", @options)
  end

  # Return extended forecast.
  def forecast_by_address(address)
    self.class.get("/forecast?q=#{address}", @options)
  end
end