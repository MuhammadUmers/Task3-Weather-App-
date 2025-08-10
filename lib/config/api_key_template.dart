// lib/config/api_keys_template.dart
//
// INSTRUCTIONS:
// 1. Copy this file and rename it to 'api_keys.dart'
// 2. Replace 'YOUR_API_KEY_HERE' with your actual OpenWeatherMap API key
// 3. Never commit the actual 'api_keys.dart' file - it's gitignored for security
//
// To get your API key:
// 1. Go to https://openweathermap.org/api
// 2. Sign up for a free account
// 3. Navigate to "My API Keys" section
// 4. Generate a new API key
//
// Example usage in your code:
// import 'package:your_app/config/api_keys.dart';
//
// final apiKey = ApiKeys.openWeatherApiKey;

class ApiKeys {
  // Replace this with your actual OpenWeatherMap API key
  static const String openWeatherApiKey = 'YOUR_API_KEY_HERE';

// Add other API keys here if needed
// static const String anotherApiKey = 'YOUR_OTHER_API_KEY_HERE';
}

// Security Notes:
// - Never hardcode API keys directly in your code
// - Always use environment variables or config files for production
// - Regularly rotate your API keys
// - Monitor your API usage to detect unauthorized access