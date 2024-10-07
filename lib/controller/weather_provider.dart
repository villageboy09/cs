// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic> _currentWeather = {};
  List<dynamic> _hourlyForecast = [];
  List<dynamic> _dailyForecast = [];
  String _locationName = '';

  Map<String, dynamic> get currentWeather => _currentWeather;
  List<dynamic> get hourlyForecast => _hourlyForecast;
  List<dynamic> get dailyForecast => _dailyForecast;
  String get locationName => _locationName;

  Future<void> fetchWeather() async {
    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          print("Location permission denied.");
          return;
        }
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Get location name
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      _locationName = placemarks.first.locality ?? 'Unknown Location';

      // Fetch weather data
      final apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';  // Load API key from environment
      if (apiKey.isEmpty) {
        throw Exception('API key is missing');
      }

      final url = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$latitude,$longitude?unitGroup=metric&key=$apiKey&contentType=json';
      final response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var today = data['days'][0];
      List<dynamic> hours = today['hours'] ?? [];

      // Get the current time
      String currentHourString = DateFormat('HH:00:00').format(DateTime.now());

      // Find the hour that matches the current time
      var currentHour = hours.firstWhere(
        (hour) => hour['datetime'] == currentHourString,
        orElse: () => hours.first, // Fallback to the first hour if not found
      );


        _currentWeather = {
          'temp': currentHour['temp'] ?? 'N/A',
          'conditions': currentHour['conditions'] ?? 'N/A',
          'humidity': currentHour['humidity'] ?? 'N/A',
          'description': today['description'] ?? 'N/A',
        };

        _hourlyForecast = today['hours'] ?? [];
        _dailyForecast = data['days'] ?? [];

        notifyListeners();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }
}
