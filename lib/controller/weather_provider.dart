// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic> _currentWeather = {};
  List<dynamic> _hourlyForecast = [];
  List<dynamic> _dailyForecast = [];
  String _locationName = '';

  Map<String, dynamic> get currentWeather => _currentWeather;
  List<dynamic> get hourlyForecast => _hourlyForecast;
  List<dynamic> get dailyForecast => _dailyForecast;
  String get locationName => _locationName;

  get weatherAlerts => null;

  Future<void> fetchWeather() async {
    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          // Handle the case when the user denies permission
          print("Location permission denied.");
          return;
        }
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Get location name
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      _locationName = placemarks.first.locality ?? 'Unknown Location';

      // Fetch weather data
      const apiKey = 'ZTEL2RQC4U6JRD847W8R2QYZG';  // Replace with your actual API key
      final url = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$latitude,$longitude?unitGroup=metric&key=$apiKey&contentType=json';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(json.encode(data));  // Print the entire data object for debugging

        // Extract current weather information
        var today = data['days'][0];
        var currentHour = today['hours'][0];

        _currentWeather = {
          'temp': currentHour['temp'] ?? 'N/A',
          'conditions': currentHour['conditions'] ?? 'N/A',
          'humidity': currentHour['humidity'] ?? 'N/A',
          'description': today['description'] ?? 'N/A',
        };

        _hourlyForecast = today['hours'] ?? [];
        _dailyForecast = data['days'] ?? [];

        print("Hourly Forecast: $_hourlyForecast");  // Debug print for hourly forecast
        print("Daily Forecast: $_dailyForecast");    // Debug print for daily forecast

        notifyListeners();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error fetching weather data: $e");
      // Handle errors here
    }
  }
}
