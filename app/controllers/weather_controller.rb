class WeatherController < ApplicationController
  def index
    api_key = Rails.application.credentials.openweathermap[:api_key]
    api = WeatherApi.new(api_key)
    address = params[:address]

    if address =~ /\A\d+\z/ # Check if the address is numeric (zip code)
      cache_key_weather = "weather/#{address}/current"
      cache_key_forecast = "weather/#{address}/forecast"

      @current_weather = Rails.cache.read(cache_key_weather)
      @extended_forecast = Rails.cache.read(cache_key_forecast)

      if @current_weather && @extended_forecast
        flash.now[:notice] = "Weather data loaded from cache."
      else
        @current_weather = api.weather_by_address(address)
        @extended_forecast = api.forecast_by_address(address)

        if @current_weather['cod'] != '404'
          Rails.cache.write(cache_key_weather, @current_weather, expires_in: 30.minutes)
          Rails.cache.write(cache_key_forecast, @extended_forecast, expires_in: 30.minutes)
        else
          flash.now[:error] = "Please check address and try again."
        end
      end
    else
      @current_weather = api.weather_by_address(address)
      @extended_forecast = api.forecast_by_address(address)

      if @current_weather['cod'] == '404'
        flash.now[:error] = "Please check address and try again."
      end
    end
  end
end
