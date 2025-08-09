import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapptask/services/weather_services.dart';
import 'package:weatherapptask/models/weathermodal.dart';


class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  CurrentWeather? _currentWeather;
  WeatherForecast? _forecast;
  bool _isLoading = false;
  String _error = '';
  String _currentCity = '';
  bool _isLocationBased = false;
  CurrentWeather? get currentWeather => _currentWeather;
  WeatherForecast? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentCity => _currentCity;
  bool get isLocationBased => _isLocationBased;
  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  // Get weather by city name
  Future<void> getWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) {
      _setError('Please enter a city name');
      return;
    }

    _setLoading(true);
    clearError();

    try {
      final currentWeatherFuture = _weatherService.getCurrentWeatherByCity(cityName);
      final forecastFuture = _weatherService.getForecastByCity(cityName);

      final results = await Future.wait([currentWeatherFuture, forecastFuture]);

      _currentWeather = results[0] as CurrentWeather;
      _forecast = results[1] as WeatherForecast;
      _currentCity = _currentWeather!.cityName;
      _isLocationBased = false;

      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch weather data: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }
  Future<void> getWeatherByCurrentLocation() async {
    _setLoading(true);
    clearError();

    try {
      Position position = await _weatherService.getCurrentLocation();
      final currentWeatherFuture = _weatherService.getCurrentWeatherByCoordinates(
          position.latitude,
          position.longitude
      );
      final forecastFuture = _weatherService.getForecastByCoordinates(
          position.latitude,
          position.longitude
      );

      final results = await Future.wait([currentWeatherFuture, forecastFuture]);

      _currentWeather = results[0] as CurrentWeather;
      _forecast = results[1] as WeatherForecast;
      _currentCity = _currentWeather!.cityName;
      _isLocationBased = true;

      _setLoading(false);
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      if (errorMessage.contains('Location')) {
        _setError('Location access denied. Please enable location services and grant permission.');
      } else {
        _setError('Failed to fetch weather data: $errorMessage');
      }
    }
  }
  Future<void> refreshWeather() async {
    if (_currentWeather == null) return;

    if (_isLocationBased) {
      await getWeatherByCurrentLocation();
    } else {
      await getWeatherByCity(_currentCity);
    }
  }
  String getWeatherIconUrl(String iconCode) {
    return _weatherService.getWeatherIconUrl(iconCode);
  }
}