require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  let(:api) { instance_double(WeatherApi) }
  let(:weather_data) { {'cod': '200', 'data': 'weather'} }
  let(:forecast_data) { {'cod': '200', 'data': 'forecast'} }
  let(:weather_data_invalid) { {'cod': '404'} }
  let(:forecast_data_invalid) { {'cod': '404'} }
  let(:address) { '12345' }
  
  before do
    allow(Rails.application.credentials).to receive(:openweathermap).and_return({ api_key: 'test_api_key' })
    allow(WeatherApi).to receive(:new).with('test_api_key').and_return(api)
  end

  describe 'GET #index' do
    context 'with a numeric address (zip code)' do
      before do
        allow(api).to receive(:weather_by_address).with(address).and_return(weather_data)
        allow(api).to receive(:forecast_by_address).with(address).and_return(forecast_data)
      end

      it 'caches the weather and forecast data' do
        expect(Rails.cache).to receive(:write).with("weather/#{address}/current", weather_data, expires_in: 30.minutes)
        expect(Rails.cache).to receive(:write).with("weather/#{address}/forecast", forecast_data, expires_in: 30.minutes)
        get :index, params: { address: address }
      end
    end

    context 'with a non-numeric address' do
      let(:address) { 'New York' }

      before do
        allow(api).to receive(:weather_by_address).with(address).and_return(weather_data)
        allow(api).to receive(:forecast_by_address).with(address).and_return(forecast_data)
      end

      it 'fetches weather and forecast data' do
        get :index, params: { address: address }
        expect(controller.instance_variable_get(:@current_weather)).to eq(weather_data)
        expect(controller.instance_variable_get(:@extended_forecast)).to eq(forecast_data)
      end
    end

    context 'with invalid address' do
      let(:address) { 'abcdefghij' }

      before do
        allow(api).to receive(:weather_by_address).with(address).and_return(weather_data_invalid)
        allow(api).to receive(:forecast_by_address).with(address).and_return(forecast_data_invalid)
      end

      it 'fetches weather and forecast data' do
        get :index, params: { address: address }
        expect(controller.instance_variable_get(:@current_weather)).to eq(weather_data_invalid)
        expect(controller.instance_variable_get(:@extended_forecast)).to eq(forecast_data_invalid)
      end
    end
  end
end
