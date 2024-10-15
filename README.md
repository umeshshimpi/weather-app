Weather Forecast Application
========

**This Ruby on Rails application allows users to retrieve current weather data and a 5-day extended forecast for a given address or zip code using the OpenWeatherMap API.**

Key features:

* Current Weather Data: Displays the current temperature, high/low temperatures, and general weather conditions for the given address.
* 5-Day Extended Forecast: Displays the weather forecast for the next 5 days, including date, temperature, and weather conditions.
* Caching: Weather data is cached for numeric addresses (such as zip codes) to reduce the number of API calls and improve performance.


Caching Behavior

* If a numeric address (e.g., zip code) is provided, the current weather data and extended forecast are cached for 30 minutes.
* When a request for the same zip code is made within 30 minutes, the data is retrieved from the cache rather than making a new API call.
* The user will see a notice when the data is loaded from the cache.

Dependencies
* Ruby on Rails
* [HTTParty](https://github.com/jnunemaker/httparty) for API requests
* [OpenWeatherMap](https://openweathermap.org/api)