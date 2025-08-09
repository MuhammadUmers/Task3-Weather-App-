
class CurrentWeather {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final String main;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final String icon;
  final DateTime dateTime;

  CurrentWeather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.main,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.icon,
    required this.dateTime,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      main: json['weather'][0]['main'] ?? '',
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      icon: json['weather'][0]['icon'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}

class HourlyWeather {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  HourlyWeather({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}

class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}

class WeatherForecast {
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  WeatherForecast({
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    List<HourlyWeather> hourlyList = [];
    List<DailyWeather> dailyList = [];

    List<dynamic> list = json['list'] ?? [];

    for (int i = 0; i < list.length && i < 8; i++) {
      hourlyList.add(HourlyWeather.fromJson(list[i]));
    }

    Map<String, List<Map<String, dynamic>>> dailyGroups = {};

    for (var item in list) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      String dateKey = '${date.year}-${date.month}-${date.day}';

      if (!dailyGroups.containsKey(dateKey)) {
        dailyGroups[dateKey] = [];
      }
      dailyGroups[dateKey]!.add(item);
    }

    int dayCount = 0;
    for (var entry in dailyGroups.entries) {
      if (dayCount >= 5) break;

      List<Map<String, dynamic>> dayData = entry.value;
      double maxTemp = dayData.map((e) => (e['main']['temp_max'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
      double minTemp = dayData.map((e) => (e['main']['temp_min'] as num).toDouble()).reduce((a, b) => a < b ? a : b);

      var midDayData = dayData[dayData.length ~/ 2];

      dailyList.add(DailyWeather(
        date: DateTime.fromMillisecondsSinceEpoch(midDayData['dt'] * 1000),
        maxTemp: maxTemp,
        minTemp: minTemp,
        description: midDayData['weather'][0]['description'] ?? '',
        icon: midDayData['weather'][0]['icon'] ?? '',
        humidity: midDayData['main']['humidity'] ?? 0,
        windSpeed: (midDayData['wind']['speed'] as num).toDouble(),
      ));

      dayCount++;
    }

    return WeatherForecast(
      hourlyForecast: hourlyList,
      dailyForecast: dailyList,
    );
  }
}