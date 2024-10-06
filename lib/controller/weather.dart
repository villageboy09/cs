import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'weather_provider.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.currentWeather.isEmpty) {
            return _buildInitialView(context, weatherProvider);
          } else {
            return _buildWeatherView(context, weatherProvider);
          }
        },
      ),
    );
  }

  Widget _buildInitialView(BuildContext context, WeatherProvider weatherProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade300, Colors.blue.shade700],
        ),
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: () => weatherProvider.fetchWeather(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            'Fetch Weather',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherView(BuildContext context, WeatherProvider weatherProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.greenAccent.shade400, Colors.blue.shade700],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildWideLayout(context, weatherProvider);
            } else {
              return _buildNarrowLayout(context, weatherProvider);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, WeatherProvider weatherProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildCurrentWeather(weatherProvider),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHourlyForecast(weatherProvider),
                _buildDailyForecast(weatherProvider),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, WeatherProvider weatherProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCurrentWeather(weatherProvider),
          _buildHourlyForecast(weatherProvider),
          _buildDailyForecast(weatherProvider),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather(WeatherProvider weatherProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weatherProvider.locationName,
            style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FaIcon(_getWeatherIcon(weatherProvider.currentWeather['conditions']), size: 80, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            '${weatherProvider.currentWeather['temp']}°C',
            style: GoogleFonts.poppins(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            weatherProvider.currentWeather['conditions'],
            style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
          ),
          Text(
            weatherProvider.currentWeather['description'] ?? 'No description available',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(WeatherProvider weatherProvider) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hourly Forecast',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weatherProvider.hourlyForecast.length,
                itemBuilder: (context, index) {
                  final hourly = weatherProvider.hourlyForecast[index];
                  return _buildHourlyItem(hourly);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyItem(Map hourly) {
    String timeString = hourly['datetime'] ?? '00:00:00';
    String formattedTime = DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(timeString));

    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(formattedTime, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
          FaIcon(_getWeatherIcon(hourly['conditions']), color: Colors.white, size: 24),
          Text('${hourly['temp']}°C', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDailyForecast(WeatherProvider weatherProvider) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Forecast',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: weatherProvider.dailyForecast.length,
              itemBuilder: (context, index) {
                final daily = weatherProvider.dailyForecast[index];
                return _buildDailyItem(daily);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyItem(Map daily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(daily['datetime'], style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
          ),
          Expanded(
            flex: 1,
            child: FaIcon(_getWeatherIcon(daily['conditions']), color: Colors.white, size: 20),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${daily['tempmax']}°C / ${daily['tempmin']}°C',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

    IconData _getWeatherIcon(String? condition) {
    if (condition == null || condition.isEmpty) {
      return FontAwesomeIcons.circleQuestion;
    }
    List conditions = condition.toLowerCase().split(',').map((e) => e.trim()).toList();
    final Map conditionIcons = {
      'rain': FontAwesomeIcons.cloudRain,
      'partly cloudy': FontAwesomeIcons.cloudSun,
      'sunny': FontAwesomeIcons.sun,
      'cloudy': FontAwesomeIcons.cloud,
      'snow': FontAwesomeIcons.snowflake,
      'thunderstorm': FontAwesomeIcons.bolt,
      'overcast': FontAwesomeIcons.cloud,
    };
    final Map conditionKeywords = {
      'partially cloudy': 'partly cloudy',
      'overcast': 'overcast',
    };

    for (String cond in conditions) {
      for (String keyword in conditionKeywords.keys) {
        if (cond.contains(keyword)) {
          cond = conditionKeywords[keyword]!;
          if (conditionIcons.containsKey(cond)) {
            return conditionIcons[cond]!;
          }
        }
      }
    }
    return FontAwesomeIcons.circleQuestion;
  }
} 