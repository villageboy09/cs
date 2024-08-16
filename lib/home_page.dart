// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:ui';

import 'package:cropsync/controller/weather.dart';
import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cropsync/controller/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
  }

  @override
  void dispose() {
    // Add any disposal logic for controllers, listeners, etc. here if needed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 187, 110), // Deeper green for a more natural feel
        elevation: 0,
        title: Text(
          'CropSync',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: const Sidebar(profileImageUrl: '', userName: '',),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildCurrentWeatherWidget(context)),
            SliverToBoxAdapter(child: _buildServicesSection(context)),
            SliverToBoxAdapter(child: _buildStatsSection(context)),
            SliverToBoxAdapter(child: _buildAboutUsSection(context)),
          ],
        ),
      ),
    );
  }

Widget _buildCurrentWeatherWidget(BuildContext context) {
  return Consumer<WeatherProvider>(
    builder: (context, weatherProvider, child) {
      if (weatherProvider.currentWeather.isEmpty) {
        return _buildShimmerWeather();
      }

      final currentWeather = weatherProvider.currentWeather;
      final locationName = weatherProvider.locationName;
      final temperature = currentWeather['temp'];
      final conditions = currentWeather['conditions'];
      final weatherIcon = _getWeatherIcon(conditions);

      // Safely get wind speed and visibility with fallback values
      final windSpeed = currentWeather['windspeed']?.toString() ?? 'N/A';
      final visibility = currentWeather['visibility']?.toString() ?? 'N/A';

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WeatherPage()),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[400]!, Colors.blue[800]!],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationName,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              conditions,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          weatherIcon,
                          size: 48,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$temperature°C',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(Icons.water_drop, '${currentWeather['humidity'] ?? 'N/A'}%', 'Humidity'),
                        _buildWeatherDetail(Icons.air, '$windSpeed km/h', 'Wind'),
                        _buildWeatherDetail(Icons.visibility, '$visibility km', 'Visibility'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildWeatherDetail(IconData icon, String value, String label) {
  return Column(
    children: [
      Icon(icon, color: Colors.white, size: 24),
      const SizedBox(height: 4),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    ],
  );
}

  IconData _getWeatherIcon(String? condition) {
    print('Condition: $condition'); // Debugging line

    if (condition == null || condition.isEmpty) {
      return FontAwesomeIcons.circleQuestion;
    }

    List<String> conditions = condition.toLowerCase().split(',').map((e) => e.trim()).toList();

    final Map<String, IconData> conditionIcons = {
      'rain': FontAwesomeIcons.cloudRain,
      'partly cloudy': FontAwesomeIcons.cloudSun,
      'sunny': FontAwesomeIcons.sun,
      'cloudy': FontAwesomeIcons.cloud,
      'snow': FontAwesomeIcons.snowflake,
      'thunderstorm': FontAwesomeIcons.bolt,
      'overcast': FontAwesomeIcons.cloud
    };

    final Map<String, String> conditionKeywords = {
      'partially cloudy': 'partly cloudy',
      'overcast': 'overcast',
    };

    for (String cond in conditions) {
      for (String keyword in conditionKeywords.keys) {
        if (cond.contains(keyword)) {
          cond = conditionKeywords[keyword]!;
        }
      }

      if (conditionIcons.containsKey(cond)) {
        return conditionIcons[cond]!;
      }
    }

    return FontAwesomeIcons.circleQuestion;
  }

  Widget _buildShimmerWeather() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const SizedBox(height: 150),
      ),
    );
  }

 Widget _buildServicesSection(BuildContext context) {
  final services = [
    {'icon': Icons.landscape, 'name': 'Soil Analysis', 'description': 'Optimize your soil health'},
    {'icon': Icons.eco, 'name': 'Crop Advisory', 'description': 'Expert guidance for better yields'},
    {'icon': Icons.pest_control, 'name': 'Pest Detection', 'description': 'Keep your crops safe'},
    {'icon': Icons.cloud, 'name': 'Weather Forecast', 'description': 'Stay updated with accuracy'},
  ];

  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green[50]!, Colors.green[100]!],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Services',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Empowering farmers with cutting-edge solutions',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.green[600],
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(service);
          },
        ),
      ],
    ),
  );
}

Widget _buildServiceCard(Map<String, dynamic> service) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  service['icon'] as IconData,
                  size: 36,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                service['name'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                service['description'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.green[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildStatsSection(BuildContext context) {
  final stats = [
    {'name': 'Farmers Reached', 'value': 2500},
    {'name': 'Crops Analyzed', 'value': 50},
    {'name': 'Soil Samples Tested', 'value': 100},
    {'name': 'Weather Alerts Sent', 'value': 500},
  ];

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green[700]!, Colors.green[900]!],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Impact',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Making a difference in agriculture',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return _buildStatCard(stat);
          },
        ),
      ],
    ),
  );
}

Widget _buildStatCard(Map<String, dynamic> stat) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${stat['value']}', // Display the value directly
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stat['name'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
  Widget _buildAboutUsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF9FBE7), // Very light yellow-green for about section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About CropSync',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'At CropSync, we are dedicated to helping farmers optimize their crop yields with cutting-edge technology. From soil analysis to pest detection, our services are designed to provide actionable insights to improve farming efficiency.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}