import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/weather_home_screen.dart';
import 'provider/weather_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: WeatherHomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}