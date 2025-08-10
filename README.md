# 🌤️ Flutter Weather App

A beautiful and intuitive weather application built with Flutter that provides real-time weather information using the OpenWeatherMap API.

## ✨ Features

- **Current Weather**: Get real-time weather conditions for any location
- **5-Day Forecast**: Extended weather forecast with detailed information
- **Location-Based**: Automatic weather detection based on your current location
- **City Search**: Search weather for any city worldwide
- **Beautiful UI**: Clean and modern interface with weather animations
- **Weather Icons**: Dynamic icons that change based on weather conditions
- **Temperature Units**: Toggle between Celsius and Fahrenheit
- **Weather Details**: Humidity, wind speed, pressure, and more



## 🔧 Technologies Used

- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language
- **OpenWeatherMap API**: Weather data provider
- **HTTP**: For API calls
- **Geolocator**: For location services
- **Permission Handler**: For managing app permissions

## 📋 Prerequisites

Before running this project, make sure you have:

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Android Studio or VS Code
- An OpenWeatherMap API key (free)

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/flutter-weather-app.git
cd flutter-weather-app
```

### 2. Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Go to "My API Keys" section
4. Generate a new API key

### 3. Configure API Key

1. Navigate to `lib/config/` directory
2. Copy `api_keys_template.dart` to `api_keys.dart`:
   ```bash
   cp lib/config/api_keys_template.dart lib/config/api_keys.dart
   ```
3. Open `lib/config/api_keys.dart`
4. Replace `'YOUR_API_KEY_HERE'` with your actual OpenWeatherMap API key:
   ```dart
   class ApiKeys {
     static const String openWeatherApiKey = 'your_actual_api_key_here';
   }
   ```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```



```


## 🔐 Security Notes

⚠️ **IMPORTANT**: Never commit your actual API keys to version control!

- The `lib/config/api_keys.dart` file is gitignored for security
- Always use the `api_keys_template.dart` as a reference
- Consider using environment variables for production builds

## 🌐 API Integration

This app integrates with [OpenWeatherMap API](https://openweathermap.org/api) endpoints:

- **Current Weather**: `/weather`
- **5-Day Forecast**: `/forecast`
- **Geocoding**: `/geo/1.0/direct`

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  geolocator: ^9.0.2
  permission_handler: ^10.4.3
  intl: ^0.18.0
  cached_network_image: ^3.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a new branch for your feature:
   ```bash
   git checkout -b feature/amazing-feature
   ```
4. **Set up** your API keys using the template
5. **Make** your changes
6. **Test** your changes thoroughly
7. **Commit** your changes:
   ```bash
   git commit -m 'Add some amazing feature'
   ```
8. **Push** to your branch:
   ```bash
   git push origin feature/amazing-feature
   ```
9. **Open** a Pull Request

### For New Contributors

1. Copy `lib/config/api_keys_template.dart` to `lib/config/api_keys.dart`
2. Add your OpenWeatherMap API key to the new file
3. Run `flutter pub get`
4. You're ready to start developing!

**Remember**: Never commit your `api_keys.dart` file - it's gitignored for security reasons.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for providing the weather API
- [Flutter](https://flutter.dev/) team for the amazing framework
- [Weather Icons](https://openweathermap.org/weather-conditions) from OpenWeatherMap

## 📞 Support

If you have any questions or run into issues:

1. Check the [Issues](https://github.com/yourusername/flutter-weather-app/issues) page
2. Create a new issue if your problem isn't already listed
3. Provide detailed information about your setup and the problem

## 🔄 Changelog

### v1.0.0
- Initial release
- Current weather display
- 5-day forecast
- Location-based weather
- City search functionality

---

**Made with ❤️ using Flutter**