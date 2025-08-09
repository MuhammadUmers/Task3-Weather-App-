import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/weather_provider.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/error_widgets.dart';
import '../widgets/loading_widgets.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast_card.dart';


class WeatherHomeScreen extends StatefulWidget {
  @override
  _WeatherHomeScreenState createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load weather for a default city on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getWeatherByCity('Peshawar');
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  LinearGradient _getBackgroundGradient(String? weatherMain) {
    if (weatherMain == null) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[400]!, Colors.blue[800]!],
      );
    }

    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange[300]!, Colors.deepOrange[500]!],
        );
      case 'rain':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[600]!, Colors.grey[900]!],
        );
      case 'clouds':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[400]!, Colors.blueGrey[800]!],
        );
      case 'snow':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[200]!, Colors.blue[600]!],
        );
      case 'thunderstorm':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.indigo[600]!, Colors.purple[900]!],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[400]!, Colors.blue[800]!],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _getBackgroundGradient(
                weatherProvider.currentWeather?.main,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(weatherProvider),
                  // Tab Bar
                  _buildTabBar(),
                  // Tab Views
                  Expanded(
                    child: _buildTabBarView(weatherProvider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(WeatherProvider weatherProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Search city...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.green),
                      onPressed: () {
                        weatherProvider.getWeatherByCurrentLocation();
                        _cityController.clear();
                      },
                      tooltip: 'Use current location',
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (_cityController.text.isNotEmpty) {
                          weatherProvider.getWeatherByCity(_cityController.text);
                          _cityController.clear();
                        }
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  weatherProvider.getWeatherByCity(value);
                  _cityController.clear();
                }
              },
            ),
          ),

          // Refresh Button
          if (weatherProvider.currentWeather != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last updated: ${DateFormat('MMM dd, HH:mm').format(DateTime.now())}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: weatherProvider.isLoading
                        ? null
                        : () => weatherProvider.refreshWeather(),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Current'),
          Tab(text: 'Hourly'),
          Tab(text: '5-Day'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(WeatherProvider weatherProvider) {
    if (weatherProvider.isLoading) {
      return const LoadingWidget();
    }

    if (weatherProvider.error.isNotEmpty) {
      return ErrorDisplayWidget(
        error: weatherProvider.error,
        onRetry: () {
          weatherProvider.clearError();
          if (weatherProvider.isLocationBased) {
            weatherProvider.getWeatherByCurrentLocation();
          } else {
            weatherProvider.getWeatherByCity(weatherProvider.currentCity);
          }
        },
      );
    }

    if (weatherProvider.currentWeather == null) {
      return const Center(
        child: Text(
          'Search for a city to see weather data',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildCurrentWeatherTab(weatherProvider),
        _buildHourlyForecastTab(weatherProvider),
        _buildDailyForecastTab(weatherProvider),
      ],
    );
  }

  Widget _buildCurrentWeatherTab(WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // City and Country
          Text(
            '${weather.cityName}, ${weather.country}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Date and Time
          Text(
            DateFormat('EEEE, MMM dd, yyyy').format(weather.dateTime),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),

          // Weather Icon and Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                weatherProvider.getWeatherIconUrl(weather.icon),
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.cloud,
                    size: 100,
                    color: Colors.white,
                  );
                },
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperature.round()}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    weather.description.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Weather Details Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              WeatherCard(
                icon: Icons.thermostat,
                title: 'Feels Like',
                value: '${weather.feelsLike.round()}°C',
                iconColor: Colors.orange,
              ),
              WeatherCard(
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${weather.humidity}%',
                iconColor: Colors.blue,
              ),
              WeatherCard(
                icon: Icons.air,
                title: 'Wind Speed',
                value: '${weather.windSpeed} m/s',
                iconColor: Colors.green,
              ),
              WeatherCard(
                icon: Icons.compress,
                title: 'Pressure',
                value: '${weather.pressure} hPa',
                iconColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecastTab(WeatherProvider weatherProvider) {
    final forecast = weatherProvider.forecast;

    if (forecast == null || forecast.hourlyForecast.isEmpty) {
      return const Center(
        child: Text(
          'No hourly forecast available',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Next 24 Hours',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: forecast.hourlyForecast.length,
            itemBuilder: (context, index) {
              final hourly = forecast.hourlyForecast[index];
              return HourlyForecastCard(
                time: DateFormat('HH:mm').format(hourly.dateTime),
                temperature: '${hourly.temperature.round()}°',
                iconUrl: weatherProvider.getWeatherIconUrl(hourly.icon),
                description: hourly.description,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecastTab(WeatherProvider weatherProvider) {
    final forecast = weatherProvider.forecast;

    if (forecast == null || forecast.dailyForecast.isEmpty) {
      return const Center(
        child: Text(
          'No daily forecast available',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '5-Day Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: forecast.dailyForecast.length,
            itemBuilder: (context, index) {
              final daily = forecast.dailyForecast[index];
              return DailyForecastCard(
                day: DateFormat('EEEE').format(daily.date),
                iconUrl: weatherProvider.getWeatherIconUrl(daily.icon),
                maxTemp: daily.maxTemp.round().toString(),
                minTemp: daily.minTemp.round().toString(),
                description: daily.description,
              );
            },
          ),
        ),
      ],
    );
  }
}