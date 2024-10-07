// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'dart:ui';
import 'package:cropsync/controller/weather.dart';
import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cropsync/controller/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _requestPermission();
  }
    Future<void> _requestPermission() async {
    await _requestLocationPermission();
  }


  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print("Location permission denied.");
        // Handle denied permission gracefully.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        title: Text(
          'CropSync',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
        ),
        actions: [
          Image.asset(
            'assets/S.png',
            width: 48,
            height: 48,
          ),
        ],
      ),
      drawer: const Sidebar(
        userName: '',
        profileImagePath: '',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Obtain the WeatherProvider instance from the context
          final weatherProvider =
              Provider.of<WeatherProvider>(context, listen: false);
          await weatherProvider.fetchWeather(); // Fetch updated weather data
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
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

  @override
  bool get wantKeepAlive => true;

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
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null || condition.isEmpty) {
      return FontAwesomeIcons.circleQuestion;
    }

    List<String> conditions =
        condition.toLowerCase().split(',').map((e) => e.trim()).toList();

    final Map<String, IconData> conditionIcons = {
      'rain': FontAwesomeIcons.cloudRain,
      'partly cloudy': FontAwesomeIcons.cloudSun,
      'sunny': FontAwesomeIcons.sun,
      'cloudy': FontAwesomeIcons.cloud,
      'snow': FontAwesomeIcons.snowflake,
      'thunderstorm': FontAwesomeIcons.bolt,
      'overcast': FontAwesomeIcons.cloud,
      'snow-showers-day': FontAwesomeIcons.snowflake,
      'snow-showers-night': FontAwesomeIcons.snowflake,
      'thunder-rain': FontAwesomeIcons.cloudBolt,
      'thunder-showers-day': FontAwesomeIcons.cloudBolt,
      'thunder-showers-night': FontAwesomeIcons.cloudBolt,
      'showers-day': FontAwesomeIcons.cloudRain,
      'showers-night': FontAwesomeIcons.cloudRain,
      'fog': FontAwesomeIcons.smog,
      'wind': FontAwesomeIcons.wind,
      'partly-cloudy-day': FontAwesomeIcons.cloudSun,
      'partly-cloudy-night': FontAwesomeIcons.cloudMoon,
      'clear-day': FontAwesomeIcons.sun,
      'clear-night': FontAwesomeIcons.moon,
      'clear': FontAwesomeIcons.sun,
    };

    final Map<String, String> conditionKeywords = {
      'partially cloudy': 'partly cloudy',
      'overcast': 'overcast',
      'light rain': 'rain',
      'light snow': 'snow',
      'heavy snow': 'snow',
      'heavy rain': 'rain',
    };

    // Match condition to an icon
    for (String condition in conditions) {
      // Check for any keyword mapping first
      if (conditionKeywords.containsKey(condition)) {
        condition = conditionKeywords[condition]!;
      }
      // Return the corresponding icon if available
      if (conditionIcons.containsKey(condition)) {
        return conditionIcons[condition]!;
      }
    }

    // Default to a question mark if no match is found
    return FontAwesomeIcons.circleQuestion;
  }
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
    {
      'icon': Icons.landscape,
      'name': 'Soil Analysis',
      'description': 'Optimize your soil health',
      'route': '/catolouge',  // Add route for navigation
    },
    {
      'icon': Icons.eco,
      'name': 'Crop Advisory',
      'description': 'Expert guidance for better yields',
      'route': '/advisory',  // Add route for navigation
    },
    {
      'icon': Icons.pest_control,
      'name': 'Pest Detection',
      'description': 'Keep your crops safe',
      'route': '/contact',  // Add route for navigation
    },
    {
      'icon': Icons.cloud,
      'name': 'Weather Forecast',
      'description': 'Stay updated',
      'route': '/weather',  // Add route for navigation
    },
  ];

  return Container(
    padding: const EdgeInsets.all(16),
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
        const SizedBox(height: 16),

        // Remove the Expanded widget
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            double childAspectRatio;
            double fontSize;

            if (screenWidth > 900) {
              childAspectRatio = 1.2;
              fontSize = 16;
            } else if (screenWidth > 600) {
              childAspectRatio = isLandscape ? 1.5 : 1.1;
              fontSize = 15;
            } else {
              childAspectRatio = isLandscape ? 1.8 : 0.9;
              fontSize = 14;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Keep this as is if you want to disable scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: services.length,
              itemBuilder: (BuildContext context, int index) {
                final service = services[index];
                return _buildServiceCard(service, fontSize, context);
              },
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildServiceCard(Map service, double fontSize, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, service['route']); // Navigate to the specified route
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                service['icon'] as IconData,
                size: 32,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service['name'] as String,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              service['description'] as String,
              style: GoogleFonts.poppins(
                fontSize: fontSize - 2,
                color: Colors.green[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
        colors: [Colors.green[500]!, Colors.green[900]!],
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
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final crossAxisCount = screenWidth > 900
                ? 4
                : screenWidth > 600
                    ? 3
                    : 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return _buildStatCard(stat);
              },
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildStatCard(Map stat) {
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
          padding: const EdgeInsets.all(10), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                // Wrap text in FittedBox
                child: Text(
                  '${stat['value']}',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              FittedBox(
                // Wrap text in FittedBox
                child: Text(
                  stat['name'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
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
    color: const Color(0xFFF9FBE7),
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
