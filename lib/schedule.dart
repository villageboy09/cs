import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => WeatherCubit()..fetchWeatherData(),
        child: const WeatherPage(),
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return _buildLoadingView();
            } else if (state is WeatherLoaded) {
              return _buildWeatherView(context, state.weatherData, state.locationName);
            } else if (state is WeatherError) {
              return _buildErrorView(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherView(BuildContext context, Map<String, dynamic> weatherData, String locationName) {
    final now = DateTime.now();
    String greeting = now.hour < 12 ? 'Good Morning' : now.hour < 18 ? 'Good Afternoon' : 'Good Evening';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(locationName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            background: Image.network(
              'https://source.unsplash.com/random/?${weatherData['forecastday'][0]['day']['condition']['text']}',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCurrentWeather(weatherData['forecastday'][0]['day']),
                const SizedBox(height: 24),
                Text(
                  'Forecast',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildForecastItem(weatherData['forecastday'][index + 1]),
            childCount: weatherData['forecastday'].length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather(Map<String, dynamic> dayData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dayData['avgtemp_c']}°C',
                      style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dayData['condition']['text'],
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                ),
                SvgPicture.network(
                  'https://www.svgrepo.com/show/484082/weather-sun.svg',
                  height: 64,
                  width: 64,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail('Wind', '${dayData['maxwind_kph']} km/h'),
                _buildWeatherDetail('Rain', '${dayData['daily_chance_of_rain']}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14)),
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildForecastItem(Map<String, dynamic> forecastData) {
    return ListTile(
      leading: SvgPicture.network(
        'https://www.svgrepo.com/show/484082/weather-sun.svg',
        height: 40,
        width: 40,
      ),
      title: Text(
        DateTime.parse(forecastData['date']).toString().split(' ')[0],
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(forecastData['day']['condition']['text']),
      trailing: Text(
        '${forecastData['day']['avgtemp_c']}°C',
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: GoogleFonts.poppins(fontSize: 18)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<WeatherCubit>().fetchWeatherData(),
            child: Text('Retry', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}

// Cubit
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future<void> fetchWeatherData() async {
    emit(WeatherLoading());
    try {
      final Uri url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=3dc451cd358e4e01ae7195104240804&q=jaipur&days=3&aqi=no&alerts=no',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        emit(WeatherLoaded(
          weatherData: jsonData['forecast'],
          locationName: jsonData['location']['name'],
        ));
      } else {
        emit(WeatherError('Failed to load weather data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(WeatherError('Error fetching weather data: $e'));
    }
  }
}

// States
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Map<String, dynamic> weatherData;
  final String locationName;

  WeatherLoaded({required this.weatherData, required this.locationName});
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}