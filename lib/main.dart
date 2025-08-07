// ignore_for_file: avoid_print

import 'package:cropsync/bottm_nav_bar.dart';
import 'package:cropsync/contact_us.dart';
import 'package:cropsync/controller/language_change_controller.dart';
import 'package:cropsync/controller/weather.dart';
import 'package:cropsync/controller/weather_provider.dart';
import 'package:cropsync/courses/agronomist.dart';
import 'package:cropsync/courses/courses_page.dart';
import 'package:cropsync/crop_advisory/advisory.dart';
import 'package:cropsync/firebase_options.dart';
import 'package:cropsync/controller/fireabse.dart';
import 'package:cropsync/home_page.dart';
import 'package:cropsync/l10n/app_localizations.dart';
import 'package:cropsync/products/catologue.dart';
import 'package:cropsync/users/auth_provider.dart';
import 'package:cropsync/users/authentication.dart';
import 'package:cropsync/users/dashboard.dart';
import 'package:cropsync/users/login.dart';
import 'package:cropsync/users/privacy_policy.dart';
import 'package:cropsync/users/sidebar_provider.dart';
import 'package:cropsync/users/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  await dotenv.load(fileName: ".env");

  // Initialize language controller
  LanguageChangeController languageController = LanguageChangeController();
  await languageController.initLanguage('en'); // Initialize with English

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageChangeController>.value(
          value: languageController,
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(), // Add AuthProvider
        ),
        ChangeNotifierProvider(
          create: (context) => SidebarProvider(), // Add SidebarProvider
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeController>(
      builder: (context, controller, child) {
        return MaterialApp(
          locale: controller.appLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: const [
            Locale("en"),
            Locale("hi"),
            Locale("te"),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const BottomNavbarPage(),
            '/home': (context) => const HomePage(),
            '/dashboard': (context) => const DashboardPage(),
            '/courses': (context) => const CoursesPage(),
            '/auth': (context) => const AuthPage(),
            '/coursepage': (context) => const CourseVideoPage(),
            '/signup': (context) => const SignupPage(),
            '/login': (context) => const LoginScreen(),
            '/contact': (context) => const ContactUsPage(),
            '/privacy': (context) => const PrivacyPolicyPage(privacyPolicyText: '', websiteUrl: '',),
            '/catolouge': (context) => const ProductCatalogPage(),
            '/advisory': (context) => const CropAdvisoryPage(),
            '/weather': (context) => const WeatherPage(),
          },
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                const FirebaseMessagingInitializer(),
              ],
            );
          },
        );
      },
    );
  }
}
